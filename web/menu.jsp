<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="css/ventas.css" /> 
            <script type="text/javascript" src="js/general.js" ></script> 
            
        </head>
        <body onLoad="parserXML();">
           
            <h:form id="form1"  >
                 
                <%@ include file="WEB-INF/jspx/header.jsp" %>

                
                
                <!--%@ include file="WEB-INF/jspx/footer.jsp" %-->
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

