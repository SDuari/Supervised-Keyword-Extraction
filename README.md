# Supervised Keyword Extraction

We present a supervised framework for automatic keyword extraction from single document. We model the text as a complex network, and construct the feature set by extracting select node properties (strength (Barrat et al., 2004), eigenvector centrality, PageRank, PositionRank (Florescu & Caragea, 2017), coreness (Seidman, 1983), and clustering coefficient) from it. The training set is created from the feature set by assigning a label to each candidate keyword depending on whether the candidate is listed as a gold-standard keyword or not. The model is trained using two public datasets (Hulth2003 and SemEval2010) from scientific domain and tested using three unseen scientific corpora (Krapivin2009, WWW, and KDD) and one news corpus (500N-KPCrowd). Comparative study of the results with several recent keyword and keyphrase extraction methods establishes that the proposed method performs better in most cases. This substantiates our claim that graph-theoretic properties of words are effective discriminators between keywords and non-keywords. We support our argument by showing that the improved performance of the proposed method is statistically significant for all datasets. We also evaluate the effectiveness of the pre-trained model on Hindi and Assamese language documents. We observe that the model performs equally well for the cross-language text even though it was trained only on English language documents. This shows that the proposed method is independent of the domain, collection, and language of the training corpora.

### Journal Paper

Duari, S., & Bhatnagar, V. (2019). Complex Network based Supervised Keyword Extractor. Expert Systems with Applications, v. 140, p. 112876.

Article DOI: [10.1016/j.eswa.2019.112876](https://doi.org/10.1016/j.eswa.2019.112876)

Article Link: [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S095741741930586X), [arXiv](https://arxiv.org/pdf/1909.12009.pdf)

### Citation
```tex
@article{DUARI2020112876,
title = "Complex Network based Supervised Keyword Extractor",
journal = "Expert Systems with Applications",
volume = "140",
pages = "112876",
year = "2020",
issn = "0957-4174",
doi = "https://doi.org/10.1016/j.eswa.2019.112876",
url = "http://www.sciencedirect.com/science/article/pii/S095741741930586X",
author = "Swagata Duari and Vasudha Bhatnagar",
keywords = "Supervised keyword extraction, Complex network, Graph-theoretic node properties, Text graph."
}
```

# Description
The testing phase of the proposed supervised framework consists of the following steps.

  1. Select candidate keywords from each document, and construct the corresponding graph-of-text.
  2. Extract select node properties as features from each graph-of-text.
  3. Predict keywords using the pre-trained model.
  
In step 1, we perform document pre-processing (tokenization, text cleaning, and stopwords removal) and identify candidates using a statistical filter, σ-index (Ortuno et al., 2002), which computes normalized standard deviation of the word’s spacing distribution in successive occurrences, with higher values of σ-index indicating higher term relevance. We use CAG representation (Check our earlier work [Duari et al., 2019](http://www.sciencedirect.com/science/article/pii/S0020025518308521) and [github repo](https://github.com/SDuari/sCAKE-and-LAKE) to model texts as graphs, where the candidates are represented as nodes and links between candidates are based on a co-occurrence relation of two consecutive sentences. In particular, we link two nodes if they co-occur within two consecutive sentences. Please note that the computation of σ-index requires a word to occur at least twice in the document. Furthermore, as words in short texts do not occur frequently, we omit the computation of σ-index for documents with less than 100 unique words excluding stopwords. In such situations, each word retained after document pre-processing is considered a candidate keyword.

In step 2, we extract 6 node properties from the graph-of-texts, namely, strength, eigenvector centrality, PageRank, PositionRank, weighted coreness, and clustering coefficient. We construct the test set by assiging '?' (unknown) label to each candidate, and pass it on to the nest step for prediction.

In step 3, we predict keywords using a pre-trained model (XGBoost2). The model is available in this repository under the sub-folder 'model'.


# Usage Instruction
The proposed framework is implemented using R (version 3.3.1) and relevant packages (igraph, tm, RWeka, caret and pROC). Below, we present the pipeline for testing an unseen document.


### Pipeline for testing unseen documents
1. Run `1-create-positional-info.R` to compute positional information.

2. Run `2-compute-sigma-index.R` to compute sigma-index.

3. Run `3-create-graph.R` to create graph-of-text.

4. Run `4-extract-node-properties.R` to extract node properties from graph-of-text.

5. Run `5-XGB-predict-keywords.R` to predict keywords using pre-trained model.


# Related Project
### [sCAKE and LAKE](https://github.com/SDuari/sCAKE-and-LAKE)
sCAKE is an unsupervised method for automatic keyword extraction. LAKE is the language-agnostic version of sCAKE. The work was published in the journal of Information Sciences.
