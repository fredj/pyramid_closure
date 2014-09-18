from pyramid.config import Configurator


def includeme(config):
    # add a route for the deps.js view
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


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.scan()
    return config.make_wsgi_app()
