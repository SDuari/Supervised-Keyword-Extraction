# Datasets

We use six publicly available datasets in our experiments. The datasets are described in detail below.

1. Hulth2003 (Hulth, 2003) consists of 2000 scientific abstracts from Inspec dataset, which are further divided into training (1000 articles), test (500 articles), and validation (500 articles). Each article in Hulth2003 dataset is accompanied with two gold-standard lists - one is controlled and uses a thesaurus, and the other is uncontrolled. We combine the training and test collections from Hulth2003 (a total of 1500 articles) to form a part of the training set for our experiments, and consult the uncontrolled keywords list as a gold-standard.

2 and 3. WWW and KDD (Caragea et al., 2014) are two collections of abstracts from computer science articles published in the two well known conferences by the respective names. For both these collections, we consider only those articles which contains at least two sentences, and are accompanied by at least one gold-standard keyword.

4. Marujo2012 is a collection of 500 online news articles, which is grouped under training collection (450 articles) and test collection (50 articles). Each article is accompanied by a list of keywords assigned by human annotators through a HIT in Amazon Mechanical Turk (Marujo, Gershman, Carbonell, Frederking, & Neto, 2012). From this dataset, we use the articles under training collection (a set of 450 articles) as an unseen test set for our experiments.

5 and 6. Krapivin2009 (Krapivin, Autaeu, & Marchese, 2009) and SemEval2010 (Kim et al., 2010) are two datasets which contains full scientific articles from ACM. The Krapivin2009 dataset consists of 2304 articles and associated keywords lists. SemEval2010 consists of 284 articles, out of which 144 are grouped as training, 100 as test, and 40 as validation sets. Each document in SemEval2010 dataset is accompa- nied by three sets of keyword list - author-assigned, reader-assigned, and author-and-reader-assigned. We use the combined collection of 244 articles (training and test) as a part of the training set for our experiments, and we consult the author-and-reader-assigned keywords list as gold-standard.
