#include <omega.h>
#include <cyclops/cyclops.h>

// OSG
#include <osg/Group>
#include <osg/Vec3>
#include <osg/Uniform>
#include <osgDB/ReadFile>
#include <osgDB/FileUtils>

#include <osgEarth/MapNode>

using namespace omega;
using namespace cyclops;
using namespace osgEarth;

///////////////////////////////////////////////////////////////////////////////
class KmlLoader: public ModelLoader
{
public:
    KmlLoader() : ModelLoader("kml") {}
    virtual bool load(ModelAsset* model);
    virtual bool loadInMap(ModelAsset* model, ModelAsset* mapAsset);
    virtual bool supportsExtension(const String& ext);
};

///////////////////////////////////////////////////////////////////////////////
// Python wrapper code.
BOOST_PYTHON_MODULE(pointCloud)
{
    PYAPI_REF_CLASS_WITH_CTOR(KmlLoader, ModelLoader);
}

///////////////////////////////////////////////////////////////////////////////
bool KmlLoader::supportsExtension(const String& ext)
{
    if(StringUtils::endsWith(ext, "kml")) return true;
    return false;
}

///////////////////////////////////////////////////////////////////////////////
bool KmlLoader::load(cyclops::ModelAsset* model)
{
    return false;
}

///////////////////////////////////////////////////////////////////////////////
bool KmlLoader::loadInMap(ModelAsset* asset, ModelAsset* mapAsset)
{
    String orfp = StringUtils::replaceAll(asset->name, "*", "%1%");
    String filePath = asset->info->path;

    for(int iterator = 0; iterator < asset->numNodes; iterator++)
    {
        // If present in the string, this line will substitute %1% with the iterator number.
        if(asset->numNodes != 1)
        {
            filePath = ostr(orfp, %iterator);
        }

        String assetPath;
        if(DataManager::findFile(filePath, assetPath))
        {
            ofmsg("Loading model......%1%", %filePath);
            osgDB::Options* options = new osgDB::Options;
            options->setOptionString("noTesselateLargePolygons noTriStripPolygons noRotation");

#ifdef omegaOsgEarth_ENABLED
            if(mapAsset)
            {
                if(StringUtils::endsWith(filePath, ".kml") || StringUtils::endsWith(filePath, ".kmz"))
                {
                    omsg("Adding mapNode option");
                    MapNode *mapNode = MapNode::findMapNode(mapAsset->nodes[0]);
                    if(mapNode)
                        options->setPluginData("osgEarth::MapNode", mapNode);
                }
            }
#endif


            if(asset->info->buildKdTree)
            {
                osgDB::Registry::instance()->setBuildKdTreesHint(osgDB::ReaderWriter::Options::BUILD_KDTREES);
            }
            else
            {
                osgDB::Registry::instance()->setBuildKdTreesHint(osgDB::ReaderWriter::Options::DO_NOT_BUILD_KDTREES);
            }

            osg::Node* node = osgDB::readNodeFile(assetPath, options);
            if(node != NULL)
            {
                node = processDefaultOptions(node, asset);
                asset->nodes.push_back(node);
            }
            else
            {
                //ofwarn("loading failed: %1%", %assetPath);
                return false;
            }
        }
        else
        {
            ofwarn("could not find file: %1%", %filePath);
            return false;
        }
    }
    return true;
}
