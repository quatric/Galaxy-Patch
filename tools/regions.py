"""The four retail releases of Super Mario Galaxy and their disc versions."""

REGIONS = {
    'RMGE01': dict(label='Super Mario Galaxy (USA)', short='USA', version=0),
    'RMGP01': dict(label='Super Mario Galaxy (Europe)', short='Europe', version=0),
    'RMGJ01': dict(label='Super Mario Galaxy (Japan)', short='Japan', version=0),
    'RMGK01': dict(label='Super Mario Galaxy (Korea)', short='Korea', version=0),
}

# retail DOL sizes, to give a clear error on modified dumps
DOL_SIZES = {
    'RMGE01': 6283264,
    'RMGP01': 6283264,
    'RMGJ01': 6283232,
    'RMGK01': 6367712,
}
