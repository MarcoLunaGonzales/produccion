/*   C r o a t i a n   l a n g u a g e   f i l e   f o r   t h e   D H T M L   Calendar  v e r s i o n   0 . 9 . 2   
 
 *   A u t h o r   K r u n o s l a v   Z u b r i n i c   < k r u n o s l a v . z u b r i n i c @ v i p . h r > ,   J u n e   2 0 0 3 . 
 
 *   F e e l   f r e e   t o   u s e   t h i s   s c r i p t   u n d e r   t h e   t e r m s   o f   t h e   G N U   L e s s e r   G e n e r a l 
 
 *   P u b l i c   L i c e n s e ,   a s   l o n g   a s   y o u   d o   n o t   r e m o v e   o r   a l t e r   t h i s   n o t i c e . 
 
 */
Calendar._DN=new Array(" N e d j e l j a "," P o n e d j e l j a k "," U t o r a k ",
" S r i j e d a "," e t v r t a k "," P e t a k "," S u b o t a "," N e d j e l j a ");
Calendar._MN=new Array("S i j ea n j "," V e l j aa "," O ~u j a k "," T r a v a n j ",
" S v i b a n j "," L i p a n j "," S r p a n j "," K o l o v o z "," R u j a n ",
" L i s t o p a d "," S t u d e n i "," P r o s i n a c ");
//   t o o l t i p s 
Calendar._TT={};
Calendar._TT[" T O G G L E "]="P r o m j e n i   d a n   s   k o j i m   p o i n j e   t j e d a n ";
Calendar._TT[" P R E V _ Y E A R "]=" P r e t h o d n a   g o d i n a   ( d u g i   p r i t i s a k   z a   m e n i ) ";
Calendar._TT[" P R E V _ M O N T H "]=" P r e t h o d n i   m j e s e c   ( d u g i   p r i t i s a k   z a   m e n i ) ";
Calendar._TT[" G O _ T O D A Y "]=" I d i   n a   t e k u i   d a n ";
Calendar._TT[" N E X T _ M O N T H "]=" S l i j e d e i   m j e s e c   ( d u g i   p r i t i s a k   z a   m e n i ) ";
Calendar._TT[" N E X T _ Y E A R "]=" S l i j e d e a   g o d i n a   ( d u g i   p r i t i s a k   z a   m e n i ) ";
Calendar._TT[" S E L _ D A T E "]=" I z a b e r i t e   d a t u m ";
Calendar._TT[" D R A G _ T O _ M O V E "]=" P r i t i s n i   i   p o v u c i   z a   p r o m j e n u   p o z i c i j e ";
Calendar._TT[" P A R T _ T O D A Y "]="   ( t o d a y ) ";
Calendar._TT[" M O N _ F I R S T "]=" P r i k a ~i   p o n e d j e l j a k   k a o   p r v i   d a n ";
Calendar._TT[" S U N _ F I R S T "]=" P r i k a ~i   n e d j e l j u   k a o   p r v i   d a n ";
Calendar._TT[" C L O S E "]=" Z a t v o r i ";
Calendar._TT[" T O D A Y "]=" D a n a s ";
//   d a t e   f o r m a t s 
Calendar._TT[" D E F _ D A T E _ F O R M A T "]=" d d - m m - y ";
Calendar._TT[" T T _ D A T E _ F O R M A T "]=" D D ,   d d . m m . y ";
Calendar._TT[" W K "]=" T j e ";