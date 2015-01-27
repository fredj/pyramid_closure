from itertools import izip

from pyramid.settings import aslist

from .closure import depswriter


def pairwise(iterable):
    if isinstance(iterable, dict):
        return iterable

    a = iter(aslist(iterable))
    return izip(a, a)


def depsjs(request):
    path_to_source = {}

    settings = request.registry.settings
    pyramid_closure = settings.get("pyramid_closure")

    roots = pyramid_closure.get("roots") if pyramid_closure else settings.get("pyramid_closure.roots")
    roots = aslist(roots or [])

    roots_with_prefix = (
        pyramid_closure.get("roots_with_prefix")
        if pyramid_closure
        else settings.get("pyramid_closure.roots_with_prefix")
    )
    roots_with_prefix = pairwise(roots_with_prefix)

    request.response.content_type = 'text/javascript'

    return depswriter.MakeDepsFile(path_to_source)
