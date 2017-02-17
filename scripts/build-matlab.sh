mkdir vendors
cd vendors

EEGLAB=eeglab14_0_0b

curl -O ftp://sccn.ucsd.edu/pub/daily/${EEGLAB}.zip
unzip ${EEGLAB}.zip
rm ${EEGLAB}.zip
mv $EEGLAB eeglab