'''
IDOR
by Bruno Melo <bruno.melo@idor.org>
'''

import glob, os, csv, re
from openpyxl import Workbook, load_workbook

# Main function
def main():
    baseDir = r'..\..\..\..\..\RAW_DATA\EEG\\'
    logs = sorted(glob.glob(baseDir+r'SUBJ*\*.log'))
    for log in logs:
        report = ReportUnity(log)
        print(report.dict())
        break
    #LogsPRJ1411(baseDir + 'SVM').clearBooks(".*ROI").toXls('SVM-only-ROIs.xlsx')


# Class to export data to an ExcelFile
class ReportUnity:
    def __init__( self, fileIn ):
        self.subjid = ''
        self.file = fileIn
        self.extractReports()


    def extractReports( self ):
        rBegin = r'== FORM REPORT BEGIN =='
        rEnd = r'== FORM REPORT END =='
        fileContent = open( self.file ).read()
        #print(fileContent)
        rex = re.compile( rBegin+r'(.*?)'+rEnd, re.S|re.M )
        self.reports = rex.findall(fileContent)
        self.reportsDict = ReportUnity.reportToDict( self.reports )

    def reportToDict( reports ):
        dictOut = []
        for report in reports:
            dictR = {}
            for line in report.split('\n'):
                elems = line.split(':\t')
                if len(elems) is not 2:
                    continue
                dictR[elems[0]] = elems[1]
            dictOut.append( dictR )
        return dictOut

    def dict( self ):
        return self.reportsDict
        
# Checks if this is the main file (when imported, is not used)
if __name__ == "__main__":
   main()       