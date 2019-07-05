# CitationExplorer
A tool for using localised citation networks to aid literature discovery

NOTE: this RShiny proof-of-concept has been superceded by a fully functional javascript implementation (see https://github.com/CitationGecko/gecko-react) 

## Motivation

The search for relevant information in the ever swelling tide of scientific papers is a central feature of almost every research project. 

Most contemporary literature recommendation engines are based on keyword searches or text-mining for similarity, which can work well in some cases but is limited by the precision of the language and prior knowledge of how to describe what is being sought. 

Citations, on the other hand, represent the more fundamental flow of information and ideas over time from paper to paper, tracking the development, connection and re-incarnation of trains of thought. Indeed, following citation trails has been one of the main ways scientists have discovered literature for centuries.  

But following citations is slow. For each paper of interest it may have hundreds of references and papers citing it but not all will be relevant to you and from a single static list it’s impossible to tell which are without reading the abstracts for each one.

However, citations are far from linear -- they exist within a network. Each is connected to the others in a myriad of different ways which provide rich details about what types of knowledge they might hold. 

This project aims to allow researchers to use localised citation networks as a shortcut to finding important papers in their area. 

## In Practice

The search starts with a handful of seed papers - perhaps the ones your supervisor has written or recommended to you, or ones chosen semi-randomly to represent the idea space you’re interested in. These will provide a footing to reduce the network of all citations to subnetworks where your interest likely lies.

The first question to ask is: are there any papers cited by a lot of my seed papers? These are likely to be important foundational papers to the area you’re interested in and worth being aware of.

Similarly, we can ask if there are papers that cite a lot of my seed papers? These are likely to be more recent papers working in the same field and are probably worth reading.

These two discovery modes represent simple extensions of reference lists and cited-by lists, enhanced by leveraging the information from multiple papers to provide an additional filter for quickly identifying the most important papers.

However, with the full citation network it is trivial to go a step further into realms impossible to navigate manually. For example: we can ask which papers appear alongside your seed papers in the reference list of other papers? This captures papers parallel to your seed paper - perhaps published around the same time and on a relevant topic but which may have been missed otherwise.

Or we can pick two sets of papers representing seemingly unrelated fields and search for connections between the two. This could help you determine more easily if an idea for a novel cross-over between two fields has been done before.

And so it continues, as far as our creativity allows and the user’s needs require. We can define any number of metrics on this local network that might best identify the papers you are interested in. What’s more we can directly visualise the citation relations as a network, putting each paper in the context of the others and providing yet more insight. 

## Current Progress

A prototype has been built with RShiny, with a single set of static data based on a real research situation. 

The next steps are to begin implementing it in JavaScript (D3) to allow greater flexibility in layout and functionality.  In the future, we hope to integrate more complex importance measures for papers, add more usability features, and API-interactions to automatically download the data.

In its final embodiment, it might work best as a plugin or extension to an existing reference manager i.e. Zotero. That way you could go directly from a particular collection of papers you’ve been curating in your library to a citation network in a few clicks in order to find other papers that should be in the collection. In this case an additional colour could to used to distinguish the ‘seed papers’ used to build the network, papers that are already in your library but were not seeds and other papers not in the library at all. 
