
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
    <script>
                function validar(){
               
                   var nombre=document.getElementById('form1:nombre');
                   var alto=document.getElementById('form1:alto');
                   var largo=document.getElementById('form1:largo');
                   var ancho=document.getElementById('form1:ancho');
                   var peso=document.getElementById('form1:peso');
                   var obs=document.getElementById('form1:obs');
                
                   if(nombre.value==''){
                     alert('El Campo Cartón Corrugado esta vacío.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensión Alto esta vacío.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensión Largo esta vacío.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensión Ancho esta vacío.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vacío.');
                     peso.focus();
                     return false;
                   }
                   if(obs.value==''){
                     alert('El Campo Descripción esta vacío.');
                     obs.focus();
                     return false;
                   }
                                   
                   return true;
                }
    </script>
</head>
<body>

<h:form id="form1"  >

<div align="center">
    <br>
    <h:outputText value="Seguimiento Programa Producción de:" styleClass="tituloCabezera1"    />
    <br> <br> <b></b> <h:outputText value="#{ManagedActividadesProgramaproduccion.nombreComProd}"   /></b> 
    <br><br>
    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
        <f:facet name="header" >
            <h:outputText value="Introduzca Datos" styleClass="outputText2" style="color:#FFFFFF"   />
        </f:facet>    
        
        <h:outputText styleClass="outputText2" value="Horas Máquina"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:inputText styleClass="inputText" size="6" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.horasMaquina}" id="h_maquina"  />
        
        <h:outputText styleClass="outputText2" value="Horas Hombre"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:inputText styleClass="inputText" size="6" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.horasHombre}" id="h_hombre"  />
        
        <h:outputText  styleClass="outputText2" value="Fecha Inicio"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:panelGroup>
            <h:inputText styleClass="outputText2" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.fechaInicio}"  id="f_inicio" />
            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinicio" />
            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_inicio\" click_element_id=\"form1:imagenFinicio\"></DLCALENDAR>"  escape="false"  />
        </h:panelGroup>  

        <%--
        <h:outputText styleClass="outputText2" value="Hora Inicio"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:inputText styleClass="inputText" size="6" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.horaInicio}" id="h_inicio"  />
        --%>
         <h:outputText  styleClass="outputText2" value="Fecha Final"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:panelGroup>
            <h:inputText styleClass="outputText2" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.fechaFinal}"  id="f_final" />
            <h:graphicImage url="../img/fecha.bmp"  id="imagenFfinal" />
            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_final\" click_element_id=\"form1:imagenFfinal\"></DLCALENDAR>"  escape="false"  />
        </h:panelGroup>  
        <%--
        <h:outputText styleClass="outputText2" value="Hora Final"  />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:inputText styleClass="inputText" size="6" value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.horaFinal}" id="h_final"  />
        --%>
        <h:outputText styleClass="outputText2" value="Maquina" />
        <h:outputText styleClass="outputText2" value="::"  />
        <h:selectOneMenu value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionbean.maquinaria.codMaquina}" styleClass="outputText2">
            <f:selectItems value="#{ManagedActividadesProgramaproduccion.maquinariasSeguimientoProgramaProduccionList}" />
        </h:selectOneMenu>
        
    </h:panelGrid>
    
    <br>
    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedActividadesProgramaproduccion.modificarSeguimientoPrograma}"   onclick="return validar();" />
    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedActividadesProgramaproduccion.Cancelar}"/>
</div>

</h:form>
<script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
</body>
</html>

</f:view>

