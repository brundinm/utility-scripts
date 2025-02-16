#/bin/bash

# MRB: Tue 13-Oct-2015

# Purpose: Shell script to produce Islandora repository summary statistics

# Description: Shell script to generate Islandora repository summary
# statistics, in the broad categories of number or count statistics, and
# file space or disk usage statistics.
#
# The number or count statistical input measures are the following:
#      - number of Fedora objects
#      - number of Fedora datastreams
#      - number of Mulgara triplestore (Fedora Resource Index) RDF triples
#      - number of internal Solr document identifiers (Solr maxDoc attribute)
#      - number of searchable Solr documents (Solr numDocs attribute)
#      - number of deleted or replaced Solr documents (maxDoc - numDocs)
#        (after a commit and before merging or optimizing)
#      - number of Fedora objects unindexed in Solr (number of Fedora
#        objects minus the number of searchable Solr documents)
#
# The file space or disk usage statistical input measures are the following:
#      - file space usage for the Mulgara triplestore (Fedora Resource Index)
#      - file space usage for the Apache Solr index
#      - file space usage for the Fedora datastore
#      - file space usage for the Fedora and Drupal MySQL databases
#      - total file space usage for the Islandora repository
#
# To run the script, type the following at the command prompt:

#     sudo sh islandora_statistics.sh

# [Some ideas for this script were gleaned from this Google Group thread:
# https://groups.google.com/forum/#!topic/islandora/NgnwKJZYbpc]

date
echo "Calculating Islandora repository summary statistics . . ."

echo "          *** Number or count statistics ***"

echo "     * Number of Fedora objects:"
FedoraObjects=$(curl -s "http://localhost:8080/fedora/risearch?type=tuples&lang=itql&format=csv&dt=on&query=select%20count%20(%0Aselect%20%24object%20from%20%3C%23ri%3E%0Awhere%20%24object%20%3Cinfo%3Afedora%2Ffedora-system%3Adef%2Fmodel%23hasModel%3E%0A%3Cinfo%3Afedora%2Ffedora-system%3AFedoraObject-3.0%3E%20)%0Afrom%20%3C%23ri%3E%0Awhere%20%24object%20%3Cinfo%3Afedora%2Ffedora-system%3Adef%2Fmodel%23hasModel%3E%0A%3Cinfo%3Afedora%2Ffedora-system%3AFedoraObject-3.0%3E%3B%0A" | tail -1)
echo "$FedoraObjects Fedora objects"

echo "     * Number of Fedora datastreams:"
FedoraDatastreams=$(curl -s "http://localhost:8080/fedora/risearch?type=tuples&lang=itql&format=csv&dt=on&query=select%20count%20(%0Aselect%20%24object%20%24datastream%20from%20%3C%23ri%3E%0Awhere%20%24object%20%3Cinfo%3Afedora%2Ffedora-system%3Adef%2Fview%23disseminates%3E%0A%24datastream%20)%0Afrom%20%3C%23ri%3E%0Awhere%20%24object%20%3Cinfo%3Afedora%2Ffedora-system%3Adef%2Fview%23disseminates%3E%0A%24datastream%3B%0A" | tail -1)
echo "$FedoraDatastreams Fedora datastreams"

echo "     * Number of Mulgara triplestore (Fedora Resource Index) RDF triples:"
MulgaraTriples=$(curl -s "http://localhost:8080/fedora/risearch?type=tuples&lang=itql&format=csv&dt=on&query=select%20count%20(%20select%20%24subject%20%24predicate%20%24object%20from%20%3C%23ri%3E%20%20where%20%24subject%20%0A%24predicate%20%24object%20)%20from%20%3C%23ri%3E%20where%20%24subject%20%0A%24predicate%20%24object%3B" | tail -1)
echo "$MulgaraTriples Mulgara triplestore (Fedora Resource Index) RDF triples"

echo "     * Number of internal Solr document identifiers (Solr maxDoc attribute):"
maxDoc=`curl -s "http://localhost:8080/solr/admin/stats.jsp" | grep '<stat name=\"maxDoc\" >' -A1 | tail -n 1 | sed -e 's/^[ \t]*//;s/[ \t]*$//'`
echo "$maxDoc internal Solr document identifiers"

echo "     * Number of searchable Solr documents (Solr numDocs attribute):"
numDocs=`curl -s "http://localhost:8080/solr/admin/stats.jsp" | grep '<stat name=\"numDocs\" >' -A1 | tail -n 1 | sed -e 's/^[ \t]*//;s/[ \t]*$//'`
echo "$numDocs searchable Solr documents"

echo "     * Number of deleted or replaced Solr documents (maxDoc - numDocs)"
echo "       (after a commit and before merging or optimizing):"
delDocs="$((maxDoc - numDocs))"
echo "$delDocs deleted or replaced Solr documents"

echo "     * Number of Fedora objects unindexed in Solr (number of Fedora"
echo "       objects minus the number of searchable Solr documents):"
unindexedFedoraObjects="$((FedoraObjects - numDocs))"
echo "$unindexedFedoraObjects Fedora objects unindexed in Solr"
    
echo "          *** File space or disk usage statistics ***"

echo "     * File space usage for the Mulgara triplestore (Fedora Resource Index):"
MulgaraTriplestore=`du -sh /usr/local/fedora/data/resourceIndex`
echo "$MulgaraTriplestore"

echo "     * File space usage for the Apache Solr index:"
SolrIndex=`du -sh /usr/local/fedora/solr/data/index`
echo "$SolrIndex"

echo "     * File space usage for the Fedora datastore:"
FedoraDatastore=`du -csh /data2/usr/local/fedora/data/datastreamStore /data2/usr/local/fedora/data/objectStore`
echo "$FedoraDatastore"

echo "     * File space usage for the Fedora and Drupal MySQL databases:"
MySQLDatabases=`du -csh /var/lib/mysql/fedora3 /var/lib/mysql/drupal7 /var/lib/mysql/ibdata1`
echo "$MySQLDatabases"

echo "     * Total file space usage for the Islandora repository:"
TotalFilespace=`du -csh /usr/local/fedora/data/resourceIndex /usr/local/fedora/solr/data/index /data2/usr/local/fedora/data/datastreamStore /data2/usr/local/fedora/data/objectStore /var/lib/mysql/fedora3 /var/lib/mysql/drupal7 /var/lib/mysql/ibdata1 | tail -1 | cut -f 1`
echo "$TotalFilespace"
echo "Note: any discrepancy between the sum of the addends and the"
echo "reported total file space usage is due to rounding"
