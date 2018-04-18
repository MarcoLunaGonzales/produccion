<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<html>
    <head>
        <script>
            var statusMenu=true;
            function hideShowMenu(imagen)
            {
                statusMenu=!statusMenu;
                document.getElementById('main').cols=(statusMenu?'25,75':'32px,*');
                imagen.src=(statusMenu?'../img/hideMenu.jpg':'../img/showMenu.jpg');
            }
            function abrirVentanaAccesoModulo(url){
                document.getElementById("mainFrame").src = url;
            }
        </script>
    </head>
<frameset rows="45,*" cols="*" frameborder="yes" border="1" framespacing="0">
  <frame src="cabecera.jsf" MARGINHEIGHT="4" MARGINWIDTH="4" name="topFrame" scrolling="NO" noresize />
  <frameset cols="25,75" frameborder="yes" border="0" framespacing="0" id="main"  name="main"  >
    <frame src="jspx/tree.jsf" style="border:solid #0099ff 1px;padding:0px;" name="leftFrame"  />
    <frame src="cuerpo.jsf"  name="mainFrame" id="mainFrame" />
  </frameset>
</frameset>
</html>
