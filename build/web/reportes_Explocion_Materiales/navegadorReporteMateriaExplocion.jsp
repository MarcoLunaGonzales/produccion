<%@ page import = "java.util.Properties" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%@ page import = "java.util.*"%> 
<%@ page import = "java.text.*"%> 
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 
<%!Connection con = null;
%> 
<%    
    String codMaquinaF =Util.getParameter("codMaquinaF");
    String codigosPrograma=Util.getParameter("codigosPrograma");
    System.out.println("codMaquinaF..:"+ codMaquinaF);
    System.out.println("codigosPrograma..:"+ codigosPrograma);
%>
<html>
    <head>
        <title>Explosion de Maquinarias</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <div align="center">
            <table width="100%" >
                <tr >
                    <td colspan="3" align="center" >
                        <h4>Reporte Explosion de Maquinarias</h4>
                    </td>
                </tr>
                <tr>
                    <td align="left"><img src= "../img/cofar.png"></td> 
                    <td> </td>
                </tr>
            </table>
         <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                <tr class="">
                    <th  bgcolor="#000000"  class="outputTextBlanco"> Cod. Maquinaria</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Nombre Maquina</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Horas Hombre</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Horas Maquina</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Observacion</th>
                    <th align="center" class="outputTextBlanco"  bgcolor="#000000">Detalles</th>
                </tr>
                <%
                  try{  
                con = Util.openConnection(con);
                // COD_COMPPROD
                
                String sql =" select m.COD_MAQUINA,m.NOMBRE_MAQUINA,b.HORAS_HOMBRE,b.HORAS_MAQUINA,m.OBS_MAQUINA ";
                       sql +=" from MAQUINARIAS m, EXPLOSION_MAQUINARIAS b ";
                       sql +=" where m.COD_MAQUINA = b.COD_MAQUINARIA  " ;
                       sql +=" AND m.COD_MAQUINA IN (" + codMaquinaF + ")";
                       sql +=" and b.COD_PROGRAMA_PRODUCCION in(" + codigosPrograma + ")";
                       sql +=" order by 2";
                       
                 System.out.println("9999999999999999---->"+ codMaquinaF);      
                 System.out.println("TTTTTTTTTTTTTTTTTTTTTT-----> " + sql);
                 Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                 ResultSet rs = stmt.executeQuery(sql);
                 System.out.println("Numero de filas es --------------------->" + rs.getRow());  
                 
                 while(rs.next()){ 
                      int codmaquina=rs.getInt(1);
                      String nombremaquina=rs.getString(2);
                      float horas_hombre=rs.getFloat(3);
                      float horas_maquina=rs.getFloat(4);
                      String Observacion=rs.getString(5);
                
                      String sqlPP  = " select pp.COD_FORMULA_MAESTRA,pp.COD_COMPPROD,pp.CANT_LOTE_PRODUCCION  from   PROGRAMA_PRODUCCION pp where pp.COD_PROGRAMA_PROD in("+codigosPrograma+")";
                             
                      System.out.println("S Q L P P ::::::::------------->  " + sqlPP);        
                      Statement stPP = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                      ResultSet rsPP = stPP.executeQuery(sqlPP);  
                      int codForMaestra ;
                      int codcomProd;
                      int NombrePProd;
                      while (rsPP.next()){
                          codForMaestra = rsPP.getInt(1);
                          codcomProd = rsPP.getInt(2); 
                          NombrePProd = rsPP.getInt(3);
                 %>
                 <tr>
                      <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=codmaquina%>    </td>
                      <td class=colh align="left" style="border : solid #f2f2f2 1px;">  <%=nombremaquina%> </td>
                      <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=horas_hombre%>  </td>
                      <td class=colh align="center" style="border : solid #f2f2f2 1px;"><%=horas_maquina%> </td>
                      <td class=colh align="left" style="border : solid #f2f2f2 1px;">  <%=Observacion%>   </td>
                  <td style="border : solid #000000 1px;" >
                       <table table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">    
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Materia Prima</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%
                                String sql2 = "";                        
                                sql2 = "select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo ";
                                sql2 += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp ";
                                sql2 += " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL  and ";
                                sql2 += " pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+ codForMaestra +"'  and ";
                                sql2 += " pp.cod_programa_prod in("+codigosPrograma+") and ppd.COD_COMPPROD='"+ codcomProd +"'  and ppd.cod_lote_produccion=pp.cod_lote_produccion and ";
                                sql2 += " pp.cod_compprod=ppd.cod_compprod and m.COD_MATERIAL in ";
                                sql2 += " (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP ep  where ep.COD_FORMULA_MAESTRA='"+codForMaestra+"') ";
                                sql2 += " and pp.cod_lote_produccion='-' order by m.NOMBRE_MATERIAL ";
                                
                                System.out.println("S Q L 2 --------------------> " + sql2);
                                Statement stmt2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs2 = stmt2.executeQuery(sql2);
                                while(rs2.next()){
                                    String aux1 = rs2.getString(2);
                                    String aux2 = rs2.getString(4);
                                    String aux3 = rs2.getString(3);
                            %>
                            <tr>
                                <td align="left" class="border"> <%=aux1%> </td>
                                <td align="right" class="border"> <%=aux2%> </td>
                                <td align="right" class="border"> <%=aux3%> </td>
                            </tr>
                           <%
                            }
                            %>
                        </table>
                        
                         <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Material Reactivo</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2">Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <%
                              String sql3 = "";
                              sql3 = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo ";
                              sql3 += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp ";
                              sql3 += " where  um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL  and pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and ";
                              sql3 += " pp.cod_formula_maestra = '"+ codForMaestra +"'  and pp.cod_programa_prod in("+codigosPrograma+") and ppd.COD_COMPPROD= '"+ codcomProd +"'  and ";
                              sql3 += " ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod and m.COD_MATERIAL in ";
                              sql3 += " (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR ep where ep.COD_FORMULA_MAESTRA='"+ codForMaestra +"')  and ";
                              sql3 += " pp.cod_lote_produccion='-' order by m.NOMBRE_MATERIAL";
                              
                              System.out.println("S Q L 3--------------------> " + sql3);
                              Statement stmt3 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs3 = stmt3.executeQuery(sql3);
                              while(rs2.next()){
                                    String auxR1 = rs3.getString(2);
                                    String auxR2 = rs3.getString(4);
                                    String auxR3 = rs3.getString(3);                                  
                            %>
                            
                             <tr>
                                <td align="left" class="border"> <%=auxR1%></td>
                                <td align="right" class="border"><%=auxR2%></td>
                                <td align="right" class="border"><%=auxR2%></td>
                            </tr>
                            <%
                             }
                            %>
                        </table>
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr class="">
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco">Empaque Primario</th>
                            </tr>
                            <tr class="">
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                          <%
                              String sql4 = "";                              
                              sql4 = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA ";
                              sql4 += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp ";
                              sql4 += " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL  and ";
                              sql4 += " pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+ codForMaestra +"'  and pp.cod_programa_prod in("+codigosPrograma+") and ";
                              sql4 += " ppd.COD_COMPPROD='"+ codcomProd +"'  and ppd.cod_lote_produccion=pp.cod_lote_produccion and pp.cod_compprod=ppd.cod_compprod and m.COD_MATERIAL ";
                              sql4 += " in (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP ep where ep.COD_FORMULA_MAESTRA='"+ codForMaestra +"') ";
                              sql4 += " and pp.cod_lote_produccion='-' order by m.NOMBRE_MATERIAL ";
                              
                              System.out.println("S Q L 4 --------------------> " + sql4);
                              Statement stmt4 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                              ResultSet rs4 = stmt4.executeQuery(sql4);
                              while(rs4.next()){
                                    String auxP1 = rs4.getString(2);
                                    String auxP2 = rs4.getString(4);
                                    String auxP3 = rs4.getString(3);                                  
                            %>
                            <tr>
                                <td align="left" class="border"> <%=auxP1%></td>
                                <td align="right" class="border"><%=auxP2%></td>
                                <td align="right" class="border"><%=auxP3%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>  
                        <table  align="center" class="outputText0" style="border : solid #f2f2f2 1px;" width="100%" cellpadding="0" cellspacing="0">
                            <tr >
                                <th colspan="3" bgcolor="#000000" class="outputTextBlanco" >Empaque Secundario</th>
                            </tr>
                            <tr style="border : solid #000000 1px;">
                                <th width="50%" bgcolor="#f2f2f2"   >Material</th>
                                <th align="center" class="border" width="10%" bgcolor="#f2f2f2" >Cantidad</th>
                                <th align="center" class="border" width="40%"  bgcolor="#f2f2f2" >Unidad Medida</th>
                            </tr>
                            <% 
                            String sql5 ="";                            
                            
                            sql5 = " select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA ";
                            sql5 += " from MATERIALES m,UNIDADES_MEDIDA um,PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp ";
                            sql5 += " where um.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA and m.COD_MATERIAL=ppd.COD_MATERIAL  and ";
                            sql5 += " pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and pp.cod_formula_maestra = '"+ codForMaestra +"'  and ";
                            sql5 += " pp.cod_programa_prod in("+codigosPrograma+") and ppd.COD_COMPPROD='"+ codcomProd +"'  and ppd.cod_lote_produccion=pp.cod_lote_produccion and ";
                            sql5 += " pp.cod_compprod=ppd.cod_compprod and m.COD_MATERIAL in ";
                            sql5 += " (select ep.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES ep where ep.COD_FORMULA_MAESTRA='"+ codForMaestra +"')  order by m.NOMBRE_MATERIAL ";
                              
                            System.out.println("S Q L 5--------------------> " + sql5);
                            Statement stmt5 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs5 = stmt5.executeQuery(sql5);
                            while(rs2.next()){
                                 String auxS1 = rs5.getString(2);
                                 String auxS2 = rs5.getString(4);
                                 String auxS3 = rs5.getString(3);                                  
                            %>
                            <tr>
                                <td align="left" class="border"> <%=auxS1%></td>
                                <td align="right" class="border"><%=auxS2%></td>
                                <td align="right" class="border"><%=auxS3%></td>
                            </tr>
                            <%
                            }
                            %>
                        </table>
                 </td>  
               </tr>               
                   <%
                     } 
                    } 
                   } catch(Exception e) {
                       e.printStackTrace();
                   } 
                   %>  
 
            </table>
            <br>
            <br>
            <div align="center">
            </div>
        </form>
    </body>
</html>