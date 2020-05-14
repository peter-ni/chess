# Peter Ni
# Data 101 Final Project


df <- read.csv("C:/Users/Peter/Desktop/finalproject/differentials.txt", sep="")
# Import calculated piece differentials for all games using .txt file 
# generated from preprocessing.py

df$pawndiff<-as.integer(df$pawndiff)
df$knightdiff<-as.integer(df$knightdiff)
df$bishopdiff<-as.integer(df$bishopdiff)
df$rookdiff<-as.integer(df$rookdiff)
df$queendiff<-as.integer(df$queendiff)
df$result<-as.character(df$result)
df$whiteelo<-as.integer(df$whiteelo)
df$blackelo<-as.integer(df$blackelo)
df<-df[complete.cases(df),]
df$white<-NULL
df$black<-NULL

# Clean data, removing NA values that result from AI games that I played
# and other miscellaneous NAs (such as disconnecting in the middle of a
# game).


df<-df[!df$result=='1/2-1/2',]
# Tied games will not be used in the analysis, as the piece differentials
# are generally 0 (with the rare exception of tie by threefold repetition)
# and won't contribute that much.

df$white_wins[df$result=="1-0"]<-TRUE
df$white_wins[df$result=="0-1"]<-FALSE
df$result<-NULL

# White wins (1-0)
# Black wins (0-1)


# Since we want to find the relative value of each chess piece based on the
# games I've played, we will focus on the relative strength of each piece's
# regression coefficient for a win in the model win~f(piece differentials)

# Another important factor to consider is that the players that I've faced
# may have a higher or lower ELO rating. Are we sure that a piece differential
# causes a higher probability of winning? Or is it because they are simply better?
# (Magnus Carlsen could easily beat the average player a queen and rook down)
# Thus, we will weight our regression using the ratings, giving more importance 
# to games that have a smaller ELO difference.


# This weighting is simple, as we can just use the already established ELO
# rating system which was made for this purpose (see link).
# https://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details

df$weight<-1/(1+10^((df$blackelo-df$whiteelo)/400))
df$weight<-abs(df$weight-0.5)

# Since we want to weigh close games more, we will modify the weights according
# to their proximity to 0.5 (50% chance of winning). Note that we will do this
# linearly, though doing it quadratically or logistically may yield more accurate
# results.

model<-lm(white_wins~pawndiff+knightdiff+bishopdiff+rookdiff+queendiff,
          data=df,
          weights=weight)
# Run the linear model and get coefficients:
# Coefficients:
# (Intercept)   pawndiff   knightdiff   bishopdiff     rookdiff    queendiff  
# -0.17941      0.04382      0.08955      0.04185      0.19313      0.34239  

# From these coefficients, we can see that queens are the strongest predictor of
# a win or loss. It is also interesting to note the inconsistencies of these
# coefficients with the established scoring system (P=1,K=3,B=3,R=5,R=9). We see
# that knights are worth more than double that of bishops. This might result from
# a couple reasons: (1) imperfect play at lower ranks means players might not be good
# at defending against knights and (2) the model does not account for the strength 
# of bishop pairs, as 2Bs are generally favorable to 2Ks or BK. Also, pawns are actually
# STRONGER than bishops, which is counterintuitive. This is probably because in many endgames,
# there are not too many pieces left on the board and pawns offer protection for your king. In
# addition, because bishops have bigger attacking potential, this also means that you have to 
# expend more energy protecting them. Still, the bishop coefficient is likely smaller here than
# it should be, since bishop pairs aren't considered in this model.

# It is also interesting to note that the intercept is negative, meaning that there is an inherent disadvantage
# for playing as white, which goes against the conventional wisdom that moving first
# is better. This is again mostly likely due to imperfect play: at lower ELO ratings,
# players will often play too aggressively, and white, moving first, will have an
# impetus to play aggressively since they move first, possibly resulting in a game-changing
# blunder that would have been seen by higher ranking players.

# From this analysis, if I want to improve my ranking, I should focus on protecting and
# utilizing my knights more often, maybe trading my bishops instead, which goes against
# conventional chess strategy. Moreover, I should probably choose to play as black
# more often.





