from pyramid.scaffolds import PyramidTemplate


class Template(PyramidTemplate):
    _template_dir = 'scaffold'
    summary = 'Template to use to create a Closure project'


def includeme(config):
    # add a view and a route for the Closure deps file
    config.add_view('pyramid_closure.views:depsjs', route_name='deps.js',
                    renderer='string')
    config.add_route('deps.js', '/closure-deps.js', request_method='GET')
