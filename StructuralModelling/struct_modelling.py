# Homology modeling with multiple templates
from modeller import *              # Load standard Modeller classes
from modeller.automodel import *    # Load the automodel class

log.verbose()    # request verbose output
env = environ()  # create a new MODELLER environment to build this model in

# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']

a = automodel(env,
              alnfile  = 'P11018_templates_scop.pir', # alignment filename
              knowns   = ('1meeA', '1scjA', '1a2qA', '1au9A', '1yjcA'),     # codes of the templates
              sequence = 'P11018')               # code of the target
a.starting_model= 1                 # index of the first model
a.ending_model  = 2                 # index of the last model
                                    # (determines how many models to calculate)
a.make()                            # do the actual homology modeling
