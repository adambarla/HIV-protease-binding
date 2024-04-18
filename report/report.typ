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
This involved identifying lines containing the "REMARK VINA RESULT" and capturing the first numerical value (the binding
affinity score).

I parsed the `qvina` output and found scores for all models tested for each ligand.
I then selected a ligand with the minimal score
The ligand with the lowest binding affinity score can be seen in @best_ligand.
It's structure is somewhat simmilar to Saquinavir which is not suprising.

#figure(
[
#set text(
size: 7pt,
)

#table(
columns: (40pt, auto, auto, auto, auto, auto, auto, auto, auto, auto, auto),
align: (horizon, center),
table.header(
table.cell(rowspan:2,[Ligand]), table.cell(colspan: 10, [Model]),
[1], [2], [3], [4], [5], [6], [7], [8], [9], [min],
),
..csv("figures/best_fits.csv").flatten()
)
],
caption: [Top $10$ ligands with the lowest minimal (out of all models tested) binding affinity score],
) <best_fits>

The ligand's binding affinity score was $-11.4$ kcal/mol which is less than Saquinavir's $-10.7$ kcal/mol.

#figure(
pad(16pt, image("figures/best_ligand.png", width: 100%)),
caption: [Ligand with name `fda_533` which reached the lowest binding affinity score of $-11.4$ kcal/mol out of $2116$ ligands tested],
) <best_ligand>

Text text