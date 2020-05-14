import chess
import chess.pgn as pgn

f=open("lichess_peterni.pgn")

# Import all games into list from standard .pgn file
gameList=[]
boardList=[]

while True:
    game=chess.pgn.read_game(f)
    if game is None:
        break
    gameList.append(game)

for i in range(len(gameList)):
    boardList.append(gameList[i].board())
    print(str(i+1)+"/"+str(len(gameList))+" games loaded.")

for n in range(len(boardList)):
    for move in gameList[n].mainline_moves():
        boardList[n].push(move)
    print(str(n+1)+"/"+str(len(boardList))+" games played.")
    
    
        

fout=open("differentials.txt","a")
fout.write("pawndiff knightdiff bishopdiff rookdiff queendiff result white black whiteelo blackelo")
fout.write("\n")

for n in range(len(boardList)):
    pawndiff=len(boardList[n].pieces(1,1))-len(boardList[n].pieces(1,0))
    knightdiff=len(boardList[n].pieces(2,1))-len(boardList[n].pieces(2,0))
    bishopdiff=len(boardList[n].pieces(3,1))-len(boardList[n].pieces(3,0))
    rookdiff=len(boardList[n].pieces(4,1))-len(boardList[n].pieces(4,0))
    queendiff=len(boardList[n].pieces(5,1))-len(boardList[n].pieces(5,0))   
    fout.write(str(pawndiff)+" ")
    fout.write(str(knightdiff)+" ")
    fout.write(str(bishopdiff)+" ")
    fout.write(str(rookdiff)+" ")
    fout.write(str(queendiff)+" ")
    # Calculate and write piece differentials
    fout.write(str(gameList[n].headers["Result"])+" ")
    fout.write(str(gameList[n].headers["White"])+" ")
    fout.write(str(gameList[n].headers["Black"])+" ")
    fout.write(str(gameList[n].headers["WhiteElo"])+" ")
    fout.write(str(gameList[n].headers["BlackElo"]))
    fout.write("\n")    
print("Finished writing all games.")



# black=0
# white=1
# chess.PAWN=1
# chess.KNIGHT=2
# chess.BISHOP=3
# chess.ROOK=4
# chess.QUEEN=5
# chess.KING=6



