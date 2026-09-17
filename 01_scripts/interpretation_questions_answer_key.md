# Interpretation questions — instructor answer key

Model answers for the group-discussion questions in the chapters/notebooks.
The rendered book chapters are the primary backup: every answer points at output the students produce.

## S. aureus — 01 Quality Control

**Q1. Your output prints how many genes the filter removed. Pick one of them — a gene with almost no counts in any of your 32 samples — and suggest two possible reasons it is so quiet: one biological, one technical. (USA-500 groups: remember your reads were mapped to the USA300 genome.) How could you start telling the two apart with the data you already have?**

Only a modest fraction is filtered because bacteria transcribe most of their genome under active growth — read the exact number off your own output, out of roughly 2,800 loci. Plausible reasons for a persistently low-count gene: (1) biology — genuinely silent under both lifestyles at these time points (regulons for conditions never sampled, prophage genes); (2) measurement — the locus is absent or divergent in the sequenced isolate relative to the reference, which is acute for USA-500 because its reads were aligned to the USA300 genome, not its own; (3) measurement — mapping or annotation artefacts (very short or repetitive features). With data already in hand you can rerun the notebook with the other strain setting and compare the locus, check whether neighbours in the same operon (adjacent locus tags) have counts, and inspect the MultiQC mapping metrics the chapter points to. The moral: a near-zero row in the count matrix is a statement about the measurement model as much as about the cell.

*Principle: #5 Measurement defines reality*

**Q2. The script sets planktonic as the reference, so a positive fold change means "up in biofilm". If you swapped the reference, what would change in the numbers — and what would change only in how you tell the story? For *S. aureus* living on a catheter in a patient, which lifestyle is really the "normal" one?**

Swapping the reference flips every sign and nothing else — the comparison is symmetric, so no biology changes, but the narrative does: the same locus tag from your heatmap reads 'biofilm-induced' in one telling and 'planktonic-repressed' in the other, and the two sentences suggest different mechanisms to a reader. Planktonic-as-control is a laboratory convention, not a biological claim: in device-associated and chronic infection the persistent state is the biofilm, and free-swimming growth in shaken rich medium is arguably the artificial condition. The chapter fixes the reference only so fold-change directions match the paper's biofilm-vs-planktonic contrast. The take-home is that the reference level is a choice of representation that shapes how every downstream result gets phrased.

*Principle: #3 Representation shapes understanding*

**Q3. These 50 genes are the most *variable* — not necessarily the most *important*. Could a gene that is essential for biofilm formation be missing from this heatmap? Give one reason how. (Hint: what does a count measure — and what does it miss?)**

Students should read the split off their own annotation bars rather than assume: the chapter flags 'samples split by time point first' as the thing to check, and where that holds, many top-variable loci track growth phase and metabolism rather than lifestyle per se — so the list is not automatically a biofilm-gene list. A central biofilm regulator can be absent because variance in transcript abundance is not activity: two-component systems and quorum-sensing components (e.g. the agr system acting through RNAIII) can be near-constitutively transcribed while their activity is switched post-transcriptionally or post-translationally. Constant transcription, or high expression with low variance, keeps a gene out of a top-variance list no matter how important it is. Transcript abundance is a dynamic but incomplete regulatory readout — the week's theme in one plot.

*Principle: Transcript abundance vs activity; #5 Measurement defines reality*

## S. aureus — 02 Differential Expression

**Q1. Pick one gene from your nine-panel profile plot. Looking at its two lines: is the interaction driven by the biofilm cells changing, the planktonic cells changing, or a real crossover? Now imagine sampling had stopped at 10 h — what would you have concluded about this gene? What decides the answer: the biology, or the time window you measured?**

For most of the top genes the honest claim is (b): the planktonic trace moves sharply between 10 h and 24 h (entry into stationary phase) while the biofilm trace is comparatively flat, and a few genes show true crossovers. Stopping at 10 h would shrink, erase or even reverse the apparent lifestyle difference for many of these genes, so the reported 'biofilm-vs-planktonic effect' is a joint product of the biology and the chosen sampling window. This is the week's core point: transcript abundance is a dynamic readout, and when you measure determines what you see.

*Principle: #5 Measurement defines reality — the sampling window, not biology alone, sets what the lifestyle effect appears to be*

**Q2. The hypothesis: USA500, the strongest biofilm producer in the paper's assay, should show the biggest biofilm-vs-planktonic difference at 24 h. Compare your cross-strain table with a group that analysed the other strain. Did the hypothesis hold? Suggest two possible explanations for what you see — one biological, one technical. (Hint: which reference genome were the USA500 reads mapped to?)**

The intended lesson is (i): how much biofilm a strain builds is a phenotype, while a DEG count is an mRNA-abundance readout, and they need not agree — biofilm output also depends on post-transcriptional regulation, protein activity and matrix export that RNA-seq never sees. (ii) inflates both strains' 24 h counts with stationary-phase signal, though not necessarily equally, and (iii) is the chapter's explicit caveat that USA500-specific or divergent genes may map imperfectly to USA300, mixing mapping effects into any count difference — which is why the table is a discussion starter, not a quantitative comparison. Explanation (iii) is the one students can probe with existing outputs, e.g. the QC mapping rates and whether the extreme genes look reference-specific. Whichever direction their table shows, only a qualitative conclusion is defensible.

*Principle: Transcript abundance versus activity (week quiz theme 3) / #5 Measurement defines reality — a molecular readout and a phenotype are different measurements of 'biofilm'*

## S. aureus — 03 Functional Enrichment

**Q1. From your ORA results, pick the enriched set you trust **most** and the one you trust **least**. Defend both using the numbers in your table (how many hits, how big the set, the eFDR) and whether the biology makes sense for a biofilm-planktonic switch.**

A trustworthy set has a substantial background size, many hits, a low eFDR, and an obvious link to the lifestyle switch (e.g. ribosome or aminoacyl-tRNA sets among the planktonic-up genes, consistent with fast-growing planktonic cells). The least trustworthy hits are the tiny sets: a 5/5 overlap is close to statistically inevitable once those genes are co-regulated — a single operon can produce it — so it is a statement about set size, not biology. 30/120 is more impressive because it requires coordinated behaviour across many independently regulated genes. The chapter built collections with a minimum of 5 genes per set precisely to blunt this, and the 'spurious hits' box makes the point directly: the hypergeometric test has no notion of biological plausibility — that filter is the analyst's job.

*Principle: #4 Models are controlled simplifications — the test knows overlap counts, not biology*

**Q2. Ribosome and translation gene sets score higher in planktonic cells — at the transcript level. A colleague concludes: "biofilm cells have shut down protein synthesis." Is that claim justified by your data? What else could explain fewer ribosomal transcripts in biofilm, and what measurement would settle it?**

The data licenses only 'transcripts for the growth machinery are less abundant in biofilm, controlling for time' — abundance, not activity. Equally consistent alternatives: slow-growing cells that translate less but have not shut down; cells running on stabilised, long-lived ribosomes made earlier, so current mRNA levels understate current capacity; or a subpopulation structure where only part of the biofilm dials growth down while bulk RNA-seq averages it away. The negative NES does match known biology (planktonic cells divide fast, mature biofilm slows growth), and because GSEA uses the full ranked list it is robust to the significance cutoff — but it remains a snapshot of mRNA pools. A direct activity readout — ribosome profiling, proteomics of ribosomal proteins, or a growth-rate/metabolic-labelling measurement — would be needed before claiming shutdown. This is the week's theme: transcript abundance is a dynamic but incomplete regulatory readout.

*Principle: Week theme: transcript abundance versus activity — an incomplete regulatory readout*

## Human — 01 Quality Control

**Q1. Find each donor's treated and untreated points in your PCA. Which is bigger: the difference between donors, or the shift caused by treatment? Based on that, predict which model will find more differentially expressed genes in the next notebook — `~ condition` or `~ donor + condition` — and why. Write the prediction down: you will check it.**

In the rendered PCA, **PC1 (27.7%) is donor** — each donor's two samples sit together on the same side, two donors left and two right — while **PC2 (24.6%) is treatment**: in all four donors the dexamethasone sample sits ~22–28 units above its untreated partner. So the donor spread is the slightly larger source of variation, but the treatment shift is remarkably consistent, which is exactly the situation a paired design is built for. Under `~ condition` the donor spread has nowhere to go: it inflates the dispersion estimates as unexplained noise and shrinks the test statistics; under `~ donor + condition` it is absorbed by the donor terms before condition is tested. The correct prediction is that the paired model calls more DE genes at the same FDR (3,833 vs 2,574 in script 02), and the chapter runs both designs precisely so students can check it. The model is a controlled simplification: donor baseline biology is deliberately modelled out because it is not the question being asked.

*Principle: #4 Models are controlled simplifications*

**Q2. Pick the gene with the cleanest treated/untreated split in your heatmap. Which of these can you claim from it: more transcript? more protein? more activity? Then look for *NR3C1* — the receptor dexamethasone binds to. It is a pre-existing protein: did its transcript need to change for the response you see? What does that say about what RNA-seq can and cannot show?**

The heatmap licenses exactly one claim: relative transcript abundance changed, on the VST scale, in the samples measured. More protein needs proteomics or a western; more activity needs a functional or phospho readout; 'pathway on' needs downstream target behaviour — the plot generates hypotheses about all three but demonstrates none. NR3C1 is the built-in counterexample: dexamethasone's mechanism is ligand binding and nuclear translocation of receptor protein that already exists, so the master regulator of the entire response needed no transcript change to act — and it is indeed **absent** from this top-50 list.

**What is actually in this heatmap** (worth steering groups through, since it surprises them): only three rows are genuine drug responses — **FKBP5**, **ZBTB16** and **GPX3**. The rest are 34 `make.unique` duplicate symbols from the RefSeq annotation (`HLA-C_4`, `TUBB_6`, `BAT2_2`, …, mostly MHC-region and tubulin entries) plus four sex-linked genes (**RPS4Y1**, **DDX3Y**, **USP9Y**, **KDM5D**) that vary because the donors are not all the same sex. That is the deeper lesson: "most variable" ranks annotation artefacts and donor identity above the treatment effect, which is why the next notebook tests a defined contrast instead of trusting variance. (Canonical targets like TSC22D3, KLF15, PER1 and CRISPLD2 respond strongly but are *not* among the top-50 most variable — they appear in the DE results instead.)

*Principle: Week theme 3 (transcript abundance versus activity); #5 Measurement defines reality*

## Human — 02 Differential Expression

**Q1. Your table shows the paired model (`~ donor + condition`) finds over a thousand more significant genes than the simple model — same data, same treatment. What changed? Where did the donor-to-donor differences "go" in the simple model, and why does giving them a name in the paired model make the treatment effect easier to see? Was your prediction from the QC notebook right?**

Adding donor moves between-donor baseline variation out of the residual: the simple model treats donor differences as unexplained noise, which inflates per-gene variance and shrinks the Wald statistic, while the paired model absorbs that variation, so the same treatment effect clears the significance bar for ~1,200 more genes. Supporting evidence in their outputs: samples from the same donor sit near each other in the QC notebook's PCA/sample clustering, and the DE heatmap's donor annotation shows each donor contributing one treated and one untreated column. The core point is that no model changed the data — the design formula decides which variation counts as signal and which as noise. Both formulas are simplifications; the paired one is the controlled simplification that matches how the samples were actually collected, which is why the chapter keeps it even when the counts are similar.

*Principle: #4 Models are controlled simplifications*

**Q2. Dexamethasone works by binding the glucocorticoid receptor, made by the gene *NR3C1*. Before looking: predict where *NR3C1* sits in your results — top hit, modest, or absent? Now find it in `res_df` (not the interactive table — that only holds genes passing *both* cutoffs). Two surprises are waiting: which **direction** did it move, and does it appear in your significant table at all? The drug did not switch this gene on — it bound the protein that was already there. So what did your RNA-seq actually measure about the receptor, and what did it miss?**

**The actual numbers (worth knowing before the discussion):** in `res_df`, NR3C1 has **log2FC = −0.98**, **padj = 6.5e-23**, and ranks **174th of 14,080** tested genes. So both naive predictions are wrong: it is not absent, and it is not a weak signal — it is in the top ~1% and strongly significant. Two surprises for the students:

1. **Direction — it goes DOWN.** The drug did not switch this gene on. The receptor protein was already there; ligand binding and nuclear translocation activated it, and the cell responds with negative feedback that mildly represses the receptor's own mRNA. A gene can be *the* driver of a response and still move in the "wrong" direction.
2. **It is missing from the significant table anyway.** −0.979 fails the |log2FC| ≥ 1 cutoff by 0.021, so NR3C1 drops out of `res_sig` and out of the interactive table, while downstream targets like FKBP5, TSC22D3 and ZBTB16 dominate the top. A hard threshold is a modelling choice, not a fact of biology, and here it excludes the most mechanistically important gene in the experiment by a rounding error.

The lesson is the week's abundance-versus-activity theme in a single gene: the DE table measures transcript abundance, not protein activity. What RNA-seq captured about the receptor is a feedback echo; what it could never capture — the ligand binding that actually started everything — is the part that mattered. Contrast with the known-gene check: the induced targets are the receptor's footprint, not the receptor itself.

*Principle: #5 Measurement defines reality / quiz theme 3: transcript abundance vs activity*

## Human — 03 Functional Enrichment

**Q1. Dexamethasone is prescribed to switch inflammation **off**. Find the immune and cytokine terms in your ORA results: which direction are they in — among the up-regulated or the down-regulated genes? Does that match the drug's job? Now look at the *other* direction's terms (adhesion, cytoskeleton, metal/mineral handling): those are not inflammation at all. What does that tell you about a drug that is described in one word ("anti-inflammatory") but acts through a receptor present in every cell?**

In the rendered results the immune signal is unambiguously **down-regulated**: the 100 down-terms include 'Cytokine-cytokine receptor interaction' (KEGG, p = 1.1e-7, 18 hits), 'Inflammatory mediator regulation of TRP channels', 'Interleukin-4 and Interleukin-13 signaling', 'immune system process' and 'regulation of immune system process'. The 15 up-regulated terms contain **no** immune terms at all — they are cell adhesion, 'Cytoskeleton in muscle cells', metallothionein/metal-response and mineral-absorption terms. So the direction matches the drug's job exactly, and students should be able to say so from their own table.

The richer half of the question is the other direction. Dexamethasone acts through the glucocorticoid receptor, which is present in essentially every cell type, so in airway smooth muscle its effects are not confined to inflammation: the up-regulated terms point at cytoskeletal and adhesion remodelling and at metal/zinc handling (metallothioneins are classic glucocorticoid-induced genes). 'Anti-inflammatory' is a clinical label for the effect we prescribe the drug for, not a description of everything it does to a cell — which is also why systemic glucocorticoids have wide-ranging side effects. A good group will also note that gene-set membership is unsigned: a term name tells you which annotation neighbourhood the genes live in, never which way the process moved — the direction comes from which query list the term was enriched in.

*Principle: #3 Representation shapes understanding — unsigned gene-set annotations cannot encode direction of pathway activity.*

**Q2. Everything in this chapter came from transcript abundance. Yet the molecule whose *activity* changed most — the glucocorticoid receptor (*NR3C1*) — was switched on by drug binding, not by transcription. Name one claim your enrichment tables can honestly make, one they cannot, and one experiment that would measure activity instead of abundance.**

NR3C1 does change measurably — log2FC = -0.98, padj = 6.5e-23, 174th of 14,080 genes — because glucocorticoids autorepress their own receptor's mRNA. But that number is a feedback echo, not the event that mattered: the receptor's *activation* was ligand binding and nuclear translocation of protein that already existed, which RNA-seq cannot see at all. (It also falls just short of the |log2FC| >= 1 cutoff, so it is absent from the significant-gene list that fed this chapter's enrichment.) The enrichment tables are entitled to claim 'these processes are transcriptionally responsive to dexamethasone in ASM cells'; they are not entitled to claim 'these pathways' activity changed', since abundance is an incomplete proxy for activity. Testing activity needs a different measurement: GR ChIP-seq for occupancy, phospho-proteomics or an NF-κB reporter assay, or a functional readout such as cytokine secretion after an inflammatory challenge.

*Principle: Week theme: transcript abundance versus activity / #5 Measurement defines reality — RNA-seq cannot see the ligand-activated regulator that caused everything it does see.*
