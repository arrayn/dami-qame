show: document.pdf
	chromium document.pdf

document.pdf: document.tex
	pdflatex document

toc:
	pdflatex document
	pdflatex document

clean:
	rm -f *.aux *.log *.toc *.blg *.bbl *~ *-eps-converted-to.pdf document.pdf
