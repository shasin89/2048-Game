# 2048-Game
This is a simple version of the original 2048 game. The game is developed with processing and ported to the web using processing.js.

In case you don’t know the rules, please read the rules of the original 2048 Game below. Otherwise, skip to the method i used to clone the game.

Rules to play 2048 Game:

1. 2048 played on a 4x4 grid, with numbered tiles that slide when a player moves them using the four arrow keys.

2. For every turn, a new tile will randomly appear in an empty tile with a value of either 2 or 4.

3.Tiles slide in the chosen direction as far as possible and are stopped by either another tile or the edge of board.

4. If two tiles of the same number collide, they will merge into a tile with the number multiplies by two.

5. The resulting tie cannot merge with another tile again in the same move

6.The game is won when a tile with a value of 2048 appears.

7.The game ends when there are no empty blocks and adjacent tiles with the same value.

Source: https://en.wikipedia.org/wiki/2048_(video_game)

Method:

Once of the reason why i used processing is that, it has functions that draw shapes like rectangle, circle and so on. Hence, it was easy for me to draw the board with processing compare to other languages. 

Processing is based on Java programming language and I used processing.js script from http://processingjs.org to port the program to an html site.

Okay, with the draw() function I have created the board with white empty blocks and colour number blocks. 

Rule 2 to 5  are applied in a function called play(int i,int j,boolean k) where i,j, and k are the input parameters. 

Followings are the steps that I’ve applied in the function play(int,int,boolean). To make you visualise, the steps are explained with a scenario the player has pressed the left arrow key.

1.Make a copy of the current grid and save it to a backup grid.

2.Make a visit to each backup block with two for  functions. Starting with the first row(row[0]) and column 2 (column[1]) check for empty blocks. If the block is empty, then skip to the next column.

3.If the block is not empty, calculate how many blocks it should slide in the chosen direction. The rules 3 is applied in this step. 

Direction: Left
                                        |2|2|0|4|

Block Column[1] slides to column [0] = 1 block to left

4. Compare the value of the new position of a backup block to the block that has the same position in the current grid. If both values are equal, then add the values together. Save the new value to the current grid and empty the original block.

                                      Original Current block
                                        |2|2|0|4|

                                      Backup block
                                        |2|2|0|4|

                                      Updated backup block
                                        |4|0|0|4|

Backup block column[1] has the new position of column[0]. Both back up block and original current block have the same number. They are added and the current block is updated with the new value.

5. If the position of new block in the original grid is empty, then switch the number block with the empty block.
                                        Original Current block
                                        |0|2|0|4|

                                        BackupBlock
                                        |0|2|0|4|

                                        Updated backup block
                                        |2|0|0|4|

6.Repeat the step 2 until all blocks in a column are visited.

								Original Current block
                                        |2|2|0|4|

                                        BackupBlock
                                        |4|4|0|0|

Final block arrangements when the loop for column is over.

7.Repeat the steps from step 2 to visit the remaining rows.

If you are following me, you’ll quickly notice that the first two column of the final block arrangements in step 6 did not added up to obey the rule 5. To achieve this the backup blocks are always compared to the original block rather than compared with its’ previous state. 

Conditions are applied for all directions and finally two functions are implemented in order to check the winning and losing conditions. 

We have applied all the rules and now we can play the game.  
