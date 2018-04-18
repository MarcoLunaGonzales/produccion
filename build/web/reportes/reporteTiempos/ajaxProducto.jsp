

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codProgramaProduccion=request.getParameter("codProgramaProduccion");
String codEstadoPrograma=request.getParameter("codEstadoPrograma");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String codLote=(request.getParameter("codLote")==null?"":request.getParameter("codLote"));
String codCompProd=request.getParameter("codComProd");
codProgramaProduccion = codProgramaProduccion.equals("")?"0":codProgramaProduccion;
codEstadoPrograma = codEstadoPrograma.equals("")?"0":codEstadoPrograma;
codAreaEmpresa = codAreaEmpresa.equals("")?"0":codAreaEmpresa;


StringBuilder consulta = new StringBuilder(" SELECT PPR.COD_PROGRAMA_PROD,PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado ,FM.COD_FORMULA_MAESTRA,PPR.COD_TIPO_PROGRAMA_PROD,TPPR.NOMBRE_TIPO_PROGRAMA_PROD  ");
                    consulta.append(" FROM PROGRAMA_PRODUCCION PPR");
                        consulta.append(" INNER JOIN  COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD ");
                        consulta.append(" INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = PPR.COD_FORMULA_MAESTRA  AND CPR.COD_COMPPROD = FM.COD_COMPPROD ");
                        consulta.append(" INNER JOIN TIPOS_PROGRAMA_PRODUCCION TPPR ON TPPR.COD_TIPO_PROGRAMA_PROD = PPR.COD_TIPO_PROGRAMA_PROD ");
                    consulta.append(" WHERE PPR.COD_ESTADO_PROGRAMA IN (").append(codEstadoPrograma).append(")");
                        consulta.append(" AND PPR.COD_PROGRAMA_PROD in (").append(codProgramaProduccion).append(")");
                        consulta.append(" AND CPR.COD_AREA_EMPRESA IN (").append(codAreaEmpresa).append(")");
                        if(codLote.length()>0)
                            consulta.append(" and PPR.COD_LOTE_PRODUCCION like '%").append(codLote).append("%'");
                        if(codCompProd.length()>0)
                            consulta.append(" and PPR.COD_COMPPROD IN (").append(codCompProd).append(")");
                    consulta.append(" ORDER BY CPR.nombre_prod_semiterminado ");

System.out.println("consulta Productos"+consulta.toString());
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta.toString());
out.println("<select name='codCompProd' size='15' class='inputText' multiple onchange='form1.chk_todoTipo.checked=false'>");
while(rs.next()){
     out.println("<option value=\"'"+rs.getString("COD_LOTE_PRODUCCION")+rs.getString("COD_COMPPROD")+rs.getString("COD_TIPO_PROGRAMA_PROD")+"'\">"+"("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")+"("+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")"+"</option>");
    //out.println("<option value="+rs.getString("COD_LOTE_PRODUCCION")+"/"+rs.getString("COD_COMPPROD")+"/"+rs.getString("COD_TIPO_PROGRAMA_PROD")+">"+"("+rs.getString("COD_LOTE_PRODUCCION")+") "+rs.getString("nombre_prod_semiterminado")+"("+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+")"+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox'  onclick='selecccionarTodo(form1)' name='chk_todoTipo' >Todo");
%>
