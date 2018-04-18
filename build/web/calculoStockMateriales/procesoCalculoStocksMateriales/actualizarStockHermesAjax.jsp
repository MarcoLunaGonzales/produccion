<%@page contentType="text/html"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@ page import="com.cofar.util.*" %>
<%
    Connection con=null;
    String mensaje = "";
    try {
        con = Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta = new StringBuilder("INSERT INTO STOCK_PRESENTACIONES_CALCULO_STOCK(COD_PRESENTACION, STOCK_MINIMO,STOCK_MAXIMO, STOCK_REPOSICION)");
                                consulta.append(" VALUES (");
                                        consulta.append("?,");//cod presentacion
                                        consulta.append("?,");//stock minimo
                                        consulta.append("?,");//stock maximo
                                        consulta.append("?");//stock reposicion
                                consulta.append(" )");
        System.out.println("consulta registrar" + consulta.toString());
        PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
        consulta=new StringBuilder("SELECT pp.cod_presentacion,mm.stock_maximo,mm.stock_minimo,mm.stock_reposicion");
                    consulta.append(" from presentaciones_producto pp");
                            consulta.append(" inner join muestras_medicas mm on mm.codigo=pp.cod_mm_asociado");
                    consulta.append(" order by pp.cod_presentacion");
        Connection conMySql=Util.openConnectionMySql();
        Statement st=conMySql.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        while(res.next())
        {
            pst.setInt(1,res.getInt("cod_presentacion"));System.out.println("p1: "+res.getInt("cod_presentacion"));
            pst.setDouble(2,res.getDouble("stock_minimo"));System.out.println("p2: "+res.getDouble("stock_minimo"));
            pst.setDouble(3,res.getDouble("stock_maximo"));System.out.println("p3: "+res.getDouble("stock_maximo"));
            pst.setDouble(4,res.getDouble("stock_reposicion"));System.out.println("p4: "+res.getDouble("stock_reposicion"));
            if(pst.executeUpdate()>0)System.out.println("se registro el stock");
        }
        con.commit();
        mensaje = "1";
    } catch (SQLException ex) {
        mensaje = "Ocurrio un error al momento de guardar el registro";
        ex.printStackTrace();
        con.rollback();
    } catch (Exception ex) {
        mensaje = "Ocurrio un error al momento de guardar el registro,verifique los datos introducidos";
        ex.printStackTrace();
    } 
    finally
    {
        con.close();
    }
    out.clear();
    out.print(mensaje);
%>
