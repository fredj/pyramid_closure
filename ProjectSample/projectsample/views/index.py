from pyramid.view import view_config


@view_config(route_name='index',
             renderer='projectsample:templates/index.html')
def index(request):
    return {'debug': 'debug' in request.params}
