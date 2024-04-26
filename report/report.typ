#import "template.typ" : *
#show : ieee.with(
title: "Molecular Docking",
// abstract: [
//  ],
authors: (
(
name: "Adam Barla",
department: [BS7107],
location: [NTU, Singapore],
email: "n2308836j@e.ntu.edu.sg"
),
),
// index-terms: ("A", "B", "C", "D"),
// bibliography-file: "refs.bib",
)

= Preparing the protein
#figure(
pad(16pt, image("figures/saquinavir_nglview.png", width: 100%)), caption: [Saquinavir], ) <saquinavir>

= Selecting a ligand with the best fit
I used a `python` script to parse the `qvina` output files and extract the most negative binding affinity score for each
ligand out of $2116$ tested.
This involved identifying lines containing the `"REMARK VINA RESULT"` and capturing the first numerical value (the binding
affinity score).

The top $10$ best ligands selected can be seen in the @best_fits. The two top ones are just Saquinavir with some aditional hydrogens.
I decide to select the ligand with the third lowest binding affinity score was named `fda_1700` and it can be seen in @best_ligand.
It's structure is somewhat simmilar to Saquinavir which is not suprising.
It's almost identical to `fda_554` which has one missing hydrogen atom.
The ligand's binding affinity score was $-11.1$ kcal/mol which is slightly less than Saquinavir's $-11.4$ kcal/mol.

#figure(
[
#show table.cell.where(x: 10): set text(
  weight: "bold",
)
#set text(
size: 7pt,
)
#pad(16pt,
table(
stroke:  none,
columns: (40pt, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
align: (horizon, center),
table.hline(start: 0,stroke:1pt),
table.header(
table.cell(rowspan:2,[*Ligand*]), table.cell(colspan: 9, [*Model*]), table.cell(rowspan:2, [*min*]),
table.hline(start: 0,stroke:0.5pt),
[1], [2], [3], [4], [5], [6], [7], [8], [9],
),
table.hline(start: 0),
//table.vline(x: 1, start: 1),
//table.vline(x: 10, start: 1),
..csv("figures/best_fits.csv").flatten(),
table.hline(start: 0,stroke:1pt),
))
],
caption: [Top $10$ ligands with the lowest minimal (out of all models tested) binding affinity score],
) <best_fits>


#figure(
pad(16pt, image("figures/best_ligand.png", width: 100%)),
caption: [Ligand with name `fda_1700` which reached the third lowest binding affinity score of $-11.1$ kcal/mol out of $2116$ ligands tested.],
) <best_ligand>

= MD

In this section I outline the sequence of computational steps taken to prepare a molecular system for dynamic simulation using `GROMACS`.

Initially, I converted ligand's structural data from `PDBQT` to `PDB` format with _Open Babel_, separating molecules and adding of hydrogens.
Next, _Antechamber_ was used to generate a `MOL2` file, calculating `AM1-BCC` charges and setting the net charge and multiplicity.
The `parmchk2` command then created a force field modification file for missing parameters.
With `tleap`, I prepared the system using the `ff14SB` force field, incorporating ligand parameters.
The final step involved the `parmed_amber2gmx.py` script (see `scripts` folder) to convert `AMBER` files to `GROMACS` format.
Following the successful setup of the ligand, I applied `tleap` and `parmed_amber2gmx.py`steps to prepare the protein component.






#figure(
pad(16pt, image("figures/hiv1_nglview.png", width: 100%)),
caption: [HIV-1 protease variant G48T/L89M]
) <hiv1>


= MD Trajectory Analysis

