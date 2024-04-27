#import "template.typ" : *
#show : ieee.with(
title: [
    Molecular Docking and Molecular Dynamics Simulations of Ligands Against HIV-1 Protease
],
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

#show link: set text(blue)
#show link: underline

= Introduction

Molecular docking is a computational technique used to predict the binding mode of a ligand to a protein target.
It is a crucial step in drug discovery, as it can help identify potential drug candidates.
In this report, I describe the computational methods used to perform molecular docking and molecular dynamics simulations on a dataset of ligands against a protein target.
The ligands were docked against the #link("https://www.rcsb.org/structure/4qgi")[HIV-1 protease] seen in @hiv1.

HIV-1 protease is an enzyme that plays a crucial role in the replication of the human immunodeficiency virus (HIV).
It cleaves the newly synthesized polyproteins at into mature protein components of an HIV viron -- the infectious form of a virus outside of the host cell.

The docking was performed using the `qvina` software and the ligand with the best fit was selected for molecular dynamics simulation using the `GROMACS` software.
The simulation was carried a second time, this time with #link("https://en.wikipedia.org/wiki/Saquinavir")[Saquinavir], a known inhibitor of the HIV-1 protease variant G48T/L89M protein.
Both ligands were compared in terms of their Root-Mean-Square Deviation (RMSD) and other properties to determine the quality of the fit and the potential of the new ligand as a drug candidate.


#figure(
    placement: bottom,
    pad(16pt, image("figures/saquinavir_nglview.png", width: 100%)),
    caption: [Saquinavir],
) <saquinavir>


#figure(
    placement: top,
    image("figures/hiv1_nglview.png", width: 90%),
    caption: [HIV-1 protease variant G48T/L89M]
) <hiv1>

= Methods

Before performing MD I selected the ligand with the best fit from the docking results.
I used a dataset of $2116$ ligands to dock against the HIV-1 protease.
All files and scripts used in this project can be found in the repository at #link("l

== Molecular Docking

I downloaded the X-ray crystal structure of HIV-1 protease variant G48T/L89M in complex with Saquinavir from #link("https://www.rcsb.org/structure/4qgi")[`rcsb`] in a single PDB file.
Before separating the ligand from the protein, I accessed the middle atoms of the Saquinavir which was position inside of the Protease from the start. I looked at the distances to surrounding protein which can be seen in @distances in the appendix. Based on these distances, I selected atom that was the nearest to the surrounding protein. Coordinates of this atom were used as the center of the bounding box for the docking simulation. Parameters for the docking were set as follows:

```toml
center_x = 21.877
center_y = -0.510
center_z = 11.108
size_x = 20
size_y = 20
size_z = 20
```

I split the molecule into two files `saquinavir.pdb` and `hiv1.pdb` and prepared them using `prepare_receptor` and `prepare_ligand` scripts from the `qvina` software.

=== Selecting a ligand with the best fit
I used a `python` script that can be found i to parse the `qvina` output files and extract the most negative binding affinity score for each
ligand out of $2116$ tested.
This involved identifying lines containing the `"REMARK VINA RESULT"` and capturing the first numerical value (the binding
affinity score).

The top $10$ best ligands selected can be seen in the @best_fits. The two top ones are just Saquinavir with some additional hydrogen atoms.
I decide to select the ligand with the third lowest binding affinity score was named `fda_1700` and it can be seen in @best_ligand.
I was able to find the ligand in the ZINC database by converting it to SMILES format with the following command:
```bash
    obabel -ipdbqt fda_pdbqt/fda_1700.pdbqt \
    -osmi -O fda_1700.smi
```
The ligand `fda_1700` corresponds to the one with zinc id #link("https://zinc.docking.org/substances/ZINC001560410173/")[ZINC001560410173] in the database.


It's structure is somewhat similar to Saquinavir which is not surprising.
It's almost identical to `fda_554` which has one missing hydrogen atom.
The ligand's binding affinity score was $-11.1$ kcal/mol which is slightly less than Saquinavir's $-11.4$ kcal/mol.

#figure(
    placement: top,
    [
        #show table.cell.where(x: 10): set text(weight: "bold",)
        #set text(size: 9pt,)
            #table(
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
            ..csv("figures/best_fits.csv").flatten(),
            table.hline(start: 0,stroke:1pt),
        )
    ],
    caption: [Top $10$ ligands with the lowest minimal (out of all models tested) binding affinity score],
) <best_fits>



= MD

In this section I outline the sequence of computational steps taken to prepare a molecular system for dynamic simulation using `GROMACS`.

Initially, I converted ligand's structural data from `PDBQT` to `PDB` format with _Open Babel_, separating molecules and adding of hydrogens.
Next, _Antechamber_ was used to generate a `MOL2` file, calculating `AM1-BCC` charges and setting the net charge and multiplicity.
The `parmchk2` command then created a force field modification file for missing parameters.
With `tleap`, I prepared the system using the `ff14SB` force field, incorporating ligand parameters.
The final step involved the `parmed_amber2gmx.py` script (see `scripts` folder) to convert `AMBER` files to `GROMACS` format.
Following the successful setup of the ligand, I applied `tleap` and `parmed_amber2gmx.py`steps to prepare the protein component.


#figure(
    placement: bottom,
    pad(16pt, image("figures/best_ligand.png", width: 100%)),
    caption: [
        Ligand name `fda_1700` in the dataset. It's ZINC ID is ZINC001560410173. It has reached the third lowest binding affinity score of $-11.1$ kcal/mol out of $2116$ ligands tested.
    ],
) <best_ligand>



= Results

== MD Trajectory Analysis


#figure(
    placement: top,
    image("figures/rmsd.svg", width: 100%),
    caption: [
        Root-Mean-Square Deviation (RMSD) of a ligand after performing a least squares fit to a protein over time in a molecular dynamics simulation.
        Figure shows comparison of the RMSD of Saquinavir and the ligand `fda_1700`.
        The ligand's RMSD is higher than Saquinavir's which indicates worse fit.
    ]
) <rmsd>

= Discussion

= Conclusion

#colbreak()
#set heading(numbering: "1.")
#counter(heading).update(0)

= Appendix

#figure(
    image("figures/distances_nglview.png", width: 90%),
    caption: [Distances between the center atom `A/ROC100/O2A` of the Saquinavir and surrounding atoms of the Protease.]
) <distances>
