#!/usr/bin/python
# vim: et ts=4 :
'''pull external repositories into this repository'''

import os, re
import subprocess

from mercurial.i18n import _

SUPPORTED_VCSES = set(['hg', 'svn'])

def _run(ui, cmd):
    ui.debug('running subprocess: %s\n' % (cmd,))
    subprocess.call(cmd, shell=True)

def _update(ui, location, vcs, opts):
    os.chdir(location)
    if vcs == 'svn':
        _run(ui, 'svn up %s' % (opts,))
    else:
        _run(ui, 'hg pull')
        _run(ui, 'hg up %s' % (opts,))

_reStatusRev = re.compile('(-r|--revision) \d+')
def _status(ui, location, vcs, opts):
    os.chdir(location)

    if _reStatusRev.search(opts):
        opts = _reStatusRev.sub('', opts)

    if vcs == 'svn':
        _run(ui, 'svn stat %s' % (opts,))
    else:
        _run(ui, 'hg stat %s' % (opts,))

def _init(ui, url, location, vcs, rev):
    os.makedirs(location)
    if vcs == 'svn':
        _run(ui, 'svn co %s %s' % (url, location))
    else:
        _run(ui, 'hg clone %s %s' % (url, location))

def _run_on_nodes(ui, repo, func, *nodes):
    if not nodes:
        nodes = (repo.root,)

    normalized_nodes = set()
    for node in nodes:
        realnode = os.path.realpath(node)
        if os.path.isdir(realnode):
            normalized_nodes.add(os.path.normpath(realnode))

    extfile = os.path.join(repo.root, '.hgexternals')
    if not os.path.exists(extfile):
        extfile = os.path.join(repo.root, 'EXTERNALS')

    if os.path.exists(extfile):
        # parse extfile entries:
        for lineno, line in enumerate(open(extfile)):
            if line[0] == '#' or line.strip() == '':
                continue
            line = line.split()
            if len(line) < 2:
                ui.warn('line %d is malformatted in %s' % (lineno, extfile))
                continue
            name = line[0]
            url = line[1]
            vcs = 'hg'
            opts = ''
            if len(line) >= 3:
                lval = line[2].lower()
                if lval in SUPPORTED_VCSES:
                    vcs = lval
                else:
                    opts = line[2]
            if len(line) > 3:
                if opts:
                    opts += ' ' + ' '.join(line[3:])
                else:
                    opts = ' '.join(line[3:])

            # we have now: name, url, vcs, opts
            # check if root+name lies under current node
            fullname = os.path.normpath(os.path.join(repo.root, name))
            for node in normalized_nodes:
                if fullname.startswith(node):
                    func(fullname, name, url, vcs, opts)

def extstatus(ui, repo, *nodes, **opts):
    '''check external repositories status

    [PATH]... is same as for `hg externals`

    If ".hgexternals" contain option not supported by `<VCS> status` it'll
    probably be removed - if error occurs feel free to send us bugreport.
    '''

    def extstatusfunc(fullname, name, url, vcs, opts):
        curwdir = os.getcwd()
        try:
            if os.path.exists(fullname):
                ui.status("\nPerforming status on external (%s) '%s':\n" % (vcs, name))
                _status(ui, fullname, vcs, opts)
            else:
                ui.warn("No external in '%s' (forgot about `hg externals` to import?)\n" % name)
        finally:
            os.chdir(curwdir)

    _run_on_nodes(ui, repo, extstatusfunc, *nodes)

def extstatushook(ui, repo, **kwargs):
    from mercurial.dispatch import _dispatch
    from mercurial import error
    import shlex

    args = shlex.split(kwargs.get('args', ''))[1:]

    try:
        _dispatch(ui, ['extstatus'] + args)
    except error.ParseError, e:
        ui.warn("hgexternals status: %s\n" % e[1])

def externals(ui, repo, *nodes, **opts):
    '''pull external repositories into this repository

    Performs pull of external repositories into this repository.
    If one or more paths are given only externals placed within these paths will be pulled.
    If no path is given, then all external repositories will be pulled.

    The ".hgexternals" file should be placed in repository ROOT directory
    and should contain a list of entries (one per line) of the following format:

        DEST SOURCE [VCS] [OPTS]...

    [VCS] must be either hg or svn, and may be omitted (default: hg).

    [OPTS]... can be used to pass along to the update/status command, which may be
    useful in selecting a particular revision of a repository. The [OPTS] will
    be passed along as such:
    
        - hg up [OPTS]
        - svn up [OPTS]
    '''

    def externalsfunc(fullname, name, url, vcs, opts):
        curwdir = os.getcwd()
        try:
            if os.path.exists(fullname):
                ui.status("Performing update on external (%s) '%s':\n" % (vcs, name,))
                _update(ui, fullname, vcs, opts)
            else:
                ui.status("Performing pull on external (%s) '%s':\n" % (vcs, name,))
                _init(ui, url, fullname, vcs, opts)
        finally:
            os.chdir(curwdir)

    _run_on_nodes(ui, repo, externalsfunc, *nodes)

cmdtable = {
    "externals": (externals, [], _('hg externals [PATH]...')),
    "extstatus": (extstatus, [], _('hg extstatus [PATH]...')),
}
