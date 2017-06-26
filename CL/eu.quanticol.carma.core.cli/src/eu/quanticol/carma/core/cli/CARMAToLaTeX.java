package eu.quanticol.carma.core.cli;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.Arrays;
import java.util.Calendar;
import java.util.stream.Stream;

public class CARMAToLaTeX {

	private int nSpacesPerTab = 4;
	private String tabSpaces = "    ";
	private Path originalPath;
	
	public CARMAToLaTeX(Path originalPath) {
		this.originalPath = originalPath;
	}
	
	public void setSpacesPerTab(int n) {
		nSpacesPerTab = n;
		char[] spaces = new char[n];
		Arrays.fill(spaces, ' ');
		tabSpaces = new String(spaces);
	}
	
	public void writeTo(Path outputPath) {
		//read input
		
		//write
		try (PrintWriter writer = new PrintWriter(outputPath.toFile())) {
			//write preliminaries
			writePreamble(writer);
			writer.println("\\begin{document}");
			writer.println(String.format("\\title{Copy of %s}",originalPath.getFileName()));
			writer.println("\\maketitle");
			writer.println();
			writer.println("\\section{General information}");
			writer.println(String.format("This model was copied on %s from %s.",
					LocalDateTime.now()
					.format(DateTimeFormatter.ofLocalizedDateTime(FormatStyle.MEDIUM)),
					escapeLaTeX(originalPath.toString())));
			writer.println();
			
			// write model contents
			writer.println("\\section{Model contents}");
			writer.println("\\begin{verbatim}");
			copyModel(originalPath, writer);
			writer.println("\\end{verbatim}");
			writer.println();
			
			writer.println("\\end{document}");
			
		} catch (IOException e) {
			System.out.println("Could not write to output file.");
		}
	}
	
	private void writePreamble(PrintWriter writer) throws IOException {
		writer.write("\\documentclass{article}");
	}
	
	private void copyModel(Path inputPath, PrintWriter writer) throws IOException {
		// we need to replace the tabs in the .carma file with spaces in the .tex file,
		// otherwise the lines will not be indented in the generated pdf.
		Files.lines(inputPath).map(s -> (s.replace("\t",tabSpaces))).forEach(writer::println);
	}
	
	private String escapeLaTeX(String s) {
		return s.replace("\\", "\\textbackslash{}").replace("&", "\\&");
	}
	
}