open_figure = """\\begin{figure}[h!]
\centering
"""
close_figure = """\caption{Leftmost zoomed in square}
\end{figure}
"""
f = open("figures.txt", "w")
f.write(open_figure)

def get_file_part(i):
    rez = """\subfigure[Frame """ + str(i) +"""]{\n""";
    rez += "\includegraphics[width=0.30\linewidth]{../refactored/figures/"
    #rez += "part1_color_" + str(i) +"_top"
    #rez += "part1_range_" + str(i) +"_top"
    rez += "part2_" + str(i) +"_left_square"
    rez += "}}\n"
    return rez

count = 0;
for i in range(21):
    count += 1
    if i == 10:
        continue
    if count >= 20:
        count = 0
        f.write(close_figure)
        f.write("\n");
        f.write(open_figure)
    f.write(get_file_part(i))

f.write(close_figure)
f.close()
    
