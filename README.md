```
  my_manga find "assassination classroom"

  Manga found for "assassination classroom"
  =========================================
  Name                    Url
  Assasination Classroom  http://www.mangareader.net/assassination-classroom 

  => nil

  my_manga add http://www.mangareader.net/assassination-classroom

  "Assassination Classroom" added to your library!

  => nil

  my_manga list

  Manga list
  =======================================
  Name                    Chapters (read/total)
  Assassination Classroom  0/161 
  Naruto                  669/700
  Naruto Movie            10/10

  => nil

  my_manga download

  Downloading 161 Chapters from "Assassination Classroom"
  Downloading 1 Chapters from "Naruto"
  ...
  Finished Download!

  => nil

  my_manga download "Assassination Classroom"

  Downloading 0 Chapters from "Assassination Classroom"
  Finished Download!

  => nil

  my_manga download "Assassination Classroom" --from=1 --to=10

  Downloading 10 Chapters from "Assassination Classroom"
  Finished Download!

  => nil

  my_manga download "Assassination Classroom" --list=[11,13,15]

  Downloading 3 Chapters from "Assassination Classroom"
  Finished Download!

  => nil

  my_manga update

  Fetching Manga
  ...
  Updated "Assassination Classroom": 5 new Chapters.

  => nil

  my_manga update "Assassination Classroom"

  Fetching Manga
  ...
  Nothing to Update

  => nil

  my_manga list "Assasination Classroom"

  Manga details for "Assasination Classroom"
  =========================================
  Name                     Chapters (read/total)
  Assassination Classroom  161/166

  Chapters Read
  -------------
  Assasination Classroom 1
  Assasination Classroom 2
  Assasination Classroom 3
  ...
  Assasination Classroom 161

  => nil

  my_manga list -a "Naruto Movie"

  Manga details for "Naruto Movie"
  =========================================
  Name                     Chapters (read/total)
  Naruto Movie  161/166

  Chapters Read
  -------------
  Naruto Movie 1
  Naruto Movie 2
  Naruto Movie 3
  Naruto Movie 4
  Naruto Movie 5
  Naruto Movie 6
  Naruto Movie 7
  Naruto Movie 8
  Naruto Movie 9
  Naruto Movie 10

  => nil

  my_manga mark read --from=162 --to=165 "Assassination Classroom"

  Chapters 162-165 from "Assination Classroom" Marked as Read

  => nil

  my_manga mark unread --list=[2,3,4,7,8] "Naruto Movie"

  Chapters 2, 3, 4, 7, 8 from "Naruto Movie" Marked as Unread

  => nil

  my_manga list

  Manga list
  =======================================
  Name                    Chapters (read/total)
  Assasination Classroom  165/166 
  Naruto                  700/700
  Naruto Movie            5/10

  => nil

````
