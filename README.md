# Supervised Keyword Extraction

[![DOI:10.1016/j.eswa.2019.112876](https://zenodo.org/badge/DOI/10.1016/j.eswa.2019.112876.svg)](https://doi.org/10.1016/j.eswa.2019.112876) [![Generic badge](https://img.shields.io/badge/Full%20Article-ScienceDirect-orange.svg)](https://www.sciencedirect.com/science/article/pii/S095741741930586X) [![Generic badge](https://img.shields.io/badge/Preprint-arXiv-orange.svg)](https://arxiv.org/pdf/1909.12009.pdf) [![made-with-r](https://img.shields.io/badge/Made%20with-R-blue.svg)](https://www.r-project.org/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/SDuari/Supervised-Keyword-Extraction)

We present a supervised framework for automatic keyword extraction from single document. We model the text as a complex network, and construct the feature set by extracting select node properties (strength (Barrat et al., 2004), eigenvector centrality, PageRank, PositionRank (Florescu & Caragea, 2017), coreness (Seidman, 1983), and clustering coefficient) from it. The training set is created from the feature set by assigning a label to each candidate keyword depending on whether the candidate is listed as a gold-standard keyword or not. The model is trained using two public datasets (Hulth2003 and SemEval2010) from scientific domain and tested using three unseen scientific corpora (Krapivin2009, WWW, and KDD) and one news corpus (500N-KPCrowd). Comparative study of the results with several recent keyword and keyphrase extraction methods establishes that the proposed method performs better in most cases. This substantiates our claim that graph-theoretic properties of words are effective discriminators between keywords and non-keywords. We support our argument by showing that the improved performance of the proposed method is statistically significant for all datasets. We also evaluate the effectiveness of the pre-trained model on Hindi and Assamese language documents. We observe that the model performs equally well for the cross-language text even though it was trained only on English language documents. This shows that the proposed method is independent of the domain, collection, and language of the training corpora.

### Journal Paper

Duari, S., & Bhatnagar, V. (2019). Complex Network based Supervised Keyword Extractor. Expert Systems with Applications, v. 140, p. 112876.

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
  
In step 1, we perform document pre-processing (tokenization, text cleaning, and stopwords removal) and identify candidates using a statistical filter, σ-index (Ortuno et al., 2002), which computes normalized standard deviation of the word’s spacing distribution in successive occurrences, with higher values of σ-index indicating higher term relevance. We use CAG representation (Check our earlier work [Duari et al., 2019](http://www.sciencedirect.com/science/article/pii/S0020025518308521) and [github repo](https://github.com/SDuari/sCAKE-and-LAKE)) to model texts as graphs, where the candidates are represented as nodes and links between candidates are based on a co-occurrence relation of two consecutive sentences. In particular, we link two nodes if they co-occur within two consecutive sentences. Please note that the computation of σ-index requires a word to occur at least twice in the document. Furthermore, as words in short texts do not occur frequently, we omit the computation of σ-index for documents with less than 100 unique words excluding stopwords. In such situations, each word retained after document pre-processing is considered a candidate keyword.

In step 2, we extract 6 node properties from the graph-of-texts, namely, strength, eigenvector centrality, PageRank, PositionRank, coreness, and clustering coefficient. We construct the test set by assiging '?' (unknown) label to each candidate, and pass it on to the nest step for prediction.

In step 3, we predict keywords using a pre-trained model (XGBoost2). The model is available in this repository under the sub-folder 'model'.


# Usage Instruction
The proposed framework is implemented using R (version 3.3.1) and relevant packages (igraph, tm, RWeka, caret and pROC). Below, we present the pipeline for testing an unseen document.


### Pipeline for testing unseen documents
1. Run `SKE-pipeline.R`. This function execute following scripts in the given sequence. It also executes `SKE-0-helper-functions.R` to run some helper functions.

    a) `SKE-1-create-position-info-LAKE.R` to get positional information.

    b) `SKE-2-compute-sigma-index-LAKE.R` to compute sigma-index.

    c) `SKE-3-Create-graph-LAKE.R` to create graph-of-text.

    d) `SKE-4-extract-node-properties.R` to extract node properties from graph-of-text.

    e) `SKE-5-XGB-predict-keywords.R` to predict keywords using pre-trained model.


# Related Project
### [sCAKE and LAKE](https://github.com/SDuari/sCAKE-and-LAKE)
sCAKE is an unsupervised method for automatic keyword extraction. LAKE is the language-agnostic version of sCAKE. The work was published in the journal of Information Sciences.

# Further Reading
Please refer to the following papers to know more about specific algorithms.

### σ-index
Ortuno, M., Carpena, P., Bernaola-Galván, P., Munoz, E., & Somoza, A. M. (2002). Keyword detection in natural languages and DNA. EPL (Europhysics Letters), 57(5), 759.

Herrera, J. P., & Pury, P. A. (2008). Statistical keyword detection in literary corpora. The European Physical Journal B, 63(1), 135-146.

### PageRank/TextRank
Page, L., Brin, S., Motwani, R., & Winograd, T. (1999). The PageRank citation ranking: Bringing order to the web. Stanford InfoLab.

Brin, S., & Page, L. (1998). The anatomy of a large-scale hypertextual web search engine. Computer networks and ISDN systems, 30(1-7), 107-117.

Mihalcea, R., & Tarau, P. (2004). Textrank: Bringing order into text. In Proceedings of the 2004 conference on empirical methods in natural language processing (pp. 404-411).

### PositionRank
(Full paper) Florescu, C., & Caragea, C. (2017, July). Positionrank: An unsupervised approach to keyphrase extraction from scholarly documents. In Proceedings of the 55th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers) (pp. 1105-1115).

(Short paper) Florescu, C., & Caragea, C. (2017, February). A position-biased pagerank algorithm for keyphrase extraction. In Thirty-First AAAI Conference on Artificial Intelligence.

### Coreness (*k*-cores)
Seidman, S. B. (1983). Network structure and minimum degree. Social networks, 5(3), 269-287.

### Strength (weighted degree)
Barrat, A., Barthelemy, M., Pastor-Satorras, R., & Vespignani, A. (2004). The architecture of complex weighted networks. Proceedings of the national academy of sciences, 101(11), 3747-3752.

### Eigenvector Centrality and Clustering Coefficient
Zaki, M. J., Meira Jr, W., & Meira, W. (2014). Data mining and analysis: fundamental concepts and algorithms. Cambridge University Press.
