import webbrowser

def open_links_from_file(file_path):
    with open(file_path, 'r') as file:
        links = file.readlines()
        links = [link.strip() for link in links]

    for link in links:
        webbrowser.open_new_tab(link)

file_path = 'sourcesForLearning.txt'
open_links_from_file(file_path)
