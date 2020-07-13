# chess
Data-based approach to improving my chess play


lichess_peterni.pgn: This is the .pgn file, contains every single move in PGN notation of the 2835 games analyzed.

preprocessing.py: This script plays out all the chess moves in all games from the .pgn file and records each endgame state in terms of piece differential.

differentials.txt: This text file is the output of the previous preprocessing.py script.

main.r: Runs weighted regression on the differentials.txt data weighted by ELO to determine importance of each type of piece.
