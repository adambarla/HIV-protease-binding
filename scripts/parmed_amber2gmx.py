import parmed as pmd
import sys, os
# convert AMBER topology to GROMACS, CHARMM formats
molecule = sys.argv[1]
amber = pmd.load_file('{}.ambtop'.format(molecule), '{}.ambcrd'.format(molecule))
# Save a GROMACS topology and GRO file


if os.path.exists('{}.top'.format(molecule)):
    os.remove('{}.top'.format(molecule))
if os.path.exists('{}.gro'.format(molecule)):
    os.remove('{}.gro'.format(molecule))

amber.save('{}.top'.format(molecule))
amber.save('{}.gro'.format(molecule))

