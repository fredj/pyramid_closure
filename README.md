# pyramid_closure

The `pyramid_closure` package provides helpers for working with Google's
[Closure Tools](https://developers.google.com/closure) in a Pyramid
application.

Install:

```shell
$ git clone https://github.com/elemoine/pyramid_closure.git
$ cd pyramid_closure
$ make install
```

Create a project based on the `pyramid_closure` scaffold:

```shell
$ cd ..
$ pyramid_closure/.build/venv/bin/pcreate -s pyramid_closure ProjectName
```

Install and build project:

```shell
$ cd ProjectName
$ make install
```

Start development server:

```shell
$ make serve
```

Use `make help` for a list of possible targets.
