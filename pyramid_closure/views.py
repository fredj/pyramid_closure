from itertools import izip

from pyramid.settings import aslist

from .closure import depswriter


def pairwise(iterable):
    a = iter(iterable)
    return izip(a, a)


def depsjs(request):
    path_to_source = {}

    roots = aslist(request.registry.settings.get(
        'pyramid_closure.roots', []))
    for root in roots:
        path_to_source.update(depswriter._GetRelativePathToSourceDict(root))

    roots_with_prefix = aslist(request.registry.settings.get(
        'pyramid_closure.roots_with_prefix', []))
    for prefix, root in pairwise(roots_with_prefix):
        path_to_source.update(
            depswriter._GetRelativePathToSourceDict(root, prefix=prefix))

    request.response.content_type = 'text/javascript'

    return depswriter.MakeDepsFile(path_to_source)


@view_config(route_name='index',
             renderer='pyramid_closure:templates/index.mako')
def index(request):
    return {'debug': 'debug' in request.params}
