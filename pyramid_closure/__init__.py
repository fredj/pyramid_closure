from pyramid.config import Configurator


def includeme(config):
    config.add_route('deps.js', '/closure-deps.js', request_method='GET')


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.scan()
    return config.make_wsgi_app()
