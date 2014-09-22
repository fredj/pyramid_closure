from pyramid.scaffolds import PyramidTemplate


class Template(PyramidTemplate):
    _template_dir = 'scaffold'
    summary = 'Template to use to create a Closure project'


def includeme(config):
    # add a view and a route for the Closure deps file
    config.add_view('pyramid_closure.views:depsjs', route_name='deps.js',
                    renderer='string')
    config.add_route('deps.js', '/closure-deps.js', request_method='GET')

    # get file system paths to closure, openlayers and ngeo from settings
    settings = config.get_settings()
    closure_path = settings.get('pyramid_closure.closure_path')
    openlayers_path = settings.get('pyramid_closure.openlayers_path')
    ngeo_path = settings.get('pyramid_closure.ngeo_path')

    # add static views for closure, openlayers and ngeo
    config.add_static_view('closure', closure_path, cache_max_age=3600)
    config.add_static_view('ol', openlayers_path, cache_max_age=3600)
    config.add_static_view('ngeo', ngeo_path, cache_max_age=3600)
