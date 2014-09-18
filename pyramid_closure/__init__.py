from pyramid.config import Configurator


def includeme(config):
    config.add_route('deps.js', '/closure-deps.js', request_method='GET')


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    closure_library_path = settings.get(
        'pyramid_closure.closure_library_path')
    openlayers_library_path = settings.get(
        'pyramid_closure.openlayers_library_path')
    ngeo_library_path = settings.get(
        'pyramid_closure.ngeo_library_path')

    config = Configurator(settings=settings)
    config.add_static_view('closure', closure_library_path, cache_max_age=3600)
    config.add_static_view('ol', openlayers_library_path, cache_max_age=3600)
    config.add_static_view('ngeo', ngeo_library_path, cache_max_age=3600)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.scan()
    return config.make_wsgi_app()
