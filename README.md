# Supervised-Keyword-Extraction

We present a supervised framework for automatic keyword extraction from single document. We model the text as a complex network, and construct the feature set by extracting select node properties (strength, eigenvector centrality, PageRank, PositionRank [1], weighted coreness[2], and clustering coefficient) from it. The training set is created from the feature set by assigning a label to each candidate keyword depending on whether the candidate is listed as a gold-standard keyword or not. The model is trained using two public datasets (Hulth2003 and SemEval2010) from scientific domain and tested using three unseen scientific corpora (Krapivin2009, WWW, and KDD) and one news corpus (500N-KPCrowd). Comparative study of the results with several recent keyword and keyphrase extraction methods establishes that the proposed method performs better in most cases. This substantiates our claim that graph-theoretic properties of words are effective discriminators between keywords and non-keywords. We support our argument by showing that the improved performance of the proposed method is statistically significant for all datasets. We also evaluate the effectiveness of the pre-trained model on Hindi and Assamese language documents. We observe that the model performs equally well for the cross-language text even though it was trained only on English language documents. This shows that the proposed method is independent of the domain, collection, and language of the training corpora.

Journal Paper:
Duari, S., & Bhatnagar, V. (2019). Complex Network based Supervised Keyword Extractor. Expert Systems with Applications, v. 140, p. 112876.

Article DOI: https://doi.org/10.1016/j.eswa.2019.112876
Article Link: https://www.sciencedirect.com/science/article/pii/S095741741930586X

# Citation
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

# Usage Instruction



# Pipeline
