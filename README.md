# ORA-Layout
Delphi project for fast developing local client application interface to Oracle DB with plsql as a script language

I would like to introduce this project as a small but usefull part of my work.
My principal duty is to develope, support and maintain a pool of analytical tools which are used by some groups in the company.
The core difficulties that I face are due to the following factors:
These groups have different goals but same base technics to achieve them.
There is a lot of various but structured data in the Oracle DB and а bit of it is in a dozen table-like excel files.
The groups need to get some data from Oracle, to sometimes add a number of excel-tables,
mix them up through the excel-sumif or like-that, and serve it finally through the powerpoint.
The groups' goals are being constantly changed in this or that part.
Excel-sources are changed rarely.
Excel-end-algorithms and PP presentations depend on the top managemnet mood and therefore can not be algorythmized.
If your duties are a bit similar to mine you would understand me.
But I have succesefully coped with it!
I have developed two delphi-libraries.
One for fast constructing interface of grid+controlls (runtime, no need for deplhi compiler).
SEcond for multivariate bidirectional data exchange with excel application.
I put them together in one project. Used DevExpress for grids and controlls. Employed ODAC for direct oracle connect.
Added some JEDI in taste (HLEditor & CaptionButton).
Now I have one delphi-project (one exe-file), two applications (two different oracle-schemes) and four teams (about 40 users) under my support and maintainance.
Hope you would fancy to look at it and then enjoy.
