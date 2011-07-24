BASE=koepld_kemperke_me537_draft

writeup: $(BASE).tex
	pdflatex $(BASE)
	bibtex $(BASE)
	pdflatex $(BASE)
	pdflatex $(BASE)
	pdflatex $(BASE)
#	okular $(BASE).pdf

clean:
	rm -rf *.aux *.log *.bbl *.blg
