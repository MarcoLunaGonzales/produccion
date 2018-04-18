<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js"></script>
    
</head>
<body >
    
    <h:form id="form1"  >
        <div style="text-align:center">
            <h:selectOneMenu value="0" styleClass="inputText">
                <f:selectItem itemValue="0" itemLabel="texto1"/>
                <f:selectItem itemValue="1" itemLabel="texto2"/>
                <a4j:support event="onchange" reRender="form1"/>
            </h:selectOneMenu>
            <h:outputText value="#{(not empty param['form1:validar'])? 0.1 : 0}"/>
            <h:inputText id="texto" requiredMessage="valor" value="0" required="true" converterMessage="el numero incontroducido" >
                <f:validator validatorId="validatorDoubleRange"/>
                <f:attribute name="minimum" value="1"/>
                <f:attribute name="maximum" value="23"/>
                <f:attribute name="disable" value="#{(empty param['form1:validar'])}"/>
            </h:inputText>
                <h:message for="texto" styleClass="message"/>
                <div style="margin-top:1em">
                    <a4j:commandButton value="validar"  id="validar" reRender="form1"/>
                    <a4j:commandButton value="No validar" id="Novalidar" reRender="form1"/>
                </div>
        </div>
        
    </h:form>
    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
    </a4j:status>

                <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                 minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                    <div align="center">
                        <h:graphicImage value="../img/load2.gif" />
                    </div>
                </rich:modalPanel>
    

    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



