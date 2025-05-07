void setupGUI() {
  // Инициализация интерфейса ControlP5
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);
  
  Group parameters = cp5.addGroup("parameters")
    .setPosition(0,20)
    .setSize(200, 105)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(105)
    .setLabel("parameters")
     ;
   
  // Слайдер детализации
  cp5.addSlider("detail")
    .setPosition(5, 5)
    .setSize(140, 20)
    .setRange(1, 8)
    .setGroup(parameters)
    .setValue(1)
    ;
  
  //Текстовое поле детализации
  cp5.addTextfield("detail_text")
    .setPosition(5,30)
    .setSize(80, 20)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((int)detail))
    .setAutoClear(false)
    .setLabel("") 
    .setGroup(parameters)
    ;
  
  // Слайдер радиуса
  cp5.addSlider("radius")
    .setPosition(5, 55)
    .setSize(140, 20)
    .setRange(1, 100)
    .setValue(30)
    .setGroup(parameters)
    .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        float r = event.getController().getValue();
        cam.setDistance(r + 100); // автоматически отодвигаем камеру
        }
      })
    ;
  
  //Текстовое поле радиуса
  cp5.addTextfield("radius_text")
    .setPosition(5,80)
    .setSize(80, 20)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((float)radius))
    .setAutoClear(false)
    .setGroup(parameters)
    .setLabel("") 
    ;
  
  Group cutDome = cp5.addGroup("cutDome")
    .setPosition(0, 150)
    .setSize(200, 205)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(205)
    .setLabel("Cut dome")
    ;
  
  // Слайдер отсечения
  cp5.addSlider("cutoff")
    .setPosition(5, 5)
    .setSize(140, 20)
    .setRange(-1, 1)
    .setValue(0)
    .setGroup(cutDome)
    .onPress(handleInteraction)
    .onDrag(handleInteraction)
    .onRelease(e -> { /* только обновляем таймер */ })
    ;
  
  // Текстовое поле отсечения
  cp5.addTextfield("cutoff_text")
    .setPosition(5,30)
    .setSize(80, 20)
    .setGroup(cutDome)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((float)cutoff))
    .setAutoClear(false)
    .setLabel("")
    ;
  
   // Слайдер поворота плоскости отсечения по Z
  cp5.addSlider("cutoffAngleZ")
    .setPosition(5, 55)
    .setSize(140, 20)
    .setRange(0, 360)
    .setValue(0)
    .setLabel("CutRotateZ")
    .setGroup(cutDome)
    .onPress(handleInteraction)
    .onDrag(handleInteraction)
    .onRelease(e -> { /* только обновляем таймер */ })
    ;
  
  // Текстовое поле для поворота вокруг оси Z
  cp5.addTextfield("cutoffAngleZ_text")
    .setPosition(5,80)
    .setSize(80, 20)
    .setGroup(cutDome)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((float)cutoffAngleZ))
    .setAutoClear(false)
    .setLabel("") 
    ;
  
  // Слайдер для поворота вокруг оси X
  cp5.addSlider("cutoffAngleX")
    .setPosition(5, 105)
    .setSize(140, 20)
    .setRange(0, 360)
    .setValue(0)
    .setLabel("CutRotateX")
    .setGroup(cutDome)
    .onPress(handleInteraction)
    .onDrag(handleInteraction)
    .onRelease(e -> { /* только обновляем таймер */ })
    ;
  
  // Текстовое поле для поворота вокруг оси X
  cp5.addTextfield("cutoffAngleX_text")
    .setPosition(5, 130)
    .setSize(80, 20)
    .setGroup(cutDome)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((float)cutoffAngleX))
    .setAutoClear(false)
    .setLabel("") 
    ;
  
  // Слайдер для поворота вокруг оси Y
  cp5.addSlider("cutoffAngleY")
    .setPosition(5, 155)
    .setSize(140, 20)
    .setRange(0, 360)
    .setValue(0)
    .setLabel("CutRotateY")
    .setGroup(cutDome)
    .onPress(handleInteraction)
    .onDrag(handleInteraction)
    .onRelease(e -> { /* только обновляем таймер */ })
    ;
  
  // Текстовое поле для поворота вокруг оси Y
  cp5.addTextfield("cutoffAngleY_text")
    .setPosition(5, 180)
    .setSize(80, 20)
    .setGroup(cutDome)
    .setFocus(false)
    .setColor(color(255,0,0))
    .setText(str((float)cutoffAngleY))
    .setAutoClear(false)
    .setLabel("") 
    ;
  
  Group togglePolyhedron = cp5.addGroup("togglePolyhedron")
    .setPosition(0,380)
    .setSize(200, 40)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(40)
    .setLabel("Toggle Polyhedron")
    ;
    
  // Переключатель типа многогранника
  cp5.addRadioButton("radio_g1")
    .setPosition(5,5)
    .setSize(20,15)
    .addItem("icosahedron",0)
    .addItem("octahedron",1)
    .setGroup(togglePolyhedron)
    .activate(polyhedronType.equals("icosahedron") ? 0 : 1)
    ;
  
  Group methodOfDetailing = cp5.addGroup("methodOfDetailing")
    .setPosition(0,445)
    .setSize(200, 40)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(40)
    .setLabel("Method of detailing")
    ;
  
  // Переключатель типа детализации
  cp5.addRadioButton("radio_g2")
    .setPosition(5,5)
    .setSize(20,15)
    .addItem("recursion method",0)
    .addItem("alternate",1)
    .setGroup(methodOfDetailing)
    .activate(detailingType.equals("recursionMethod") ? 0 : 1)
    ;
  
  Group options = cp5.addGroup("options")
    .setPosition(0,510)
    .setSize(200, 45)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(45)
    .setLabel("options")
    ;
   
  // Переключатель отображения только рёбер
  cp5.addToggle("showEdges")
    .setPosition(5, 5)
    .setSize(50, 20)
    .setGroup(options)
    .setValue(showEdges)
    ;
  
  // Переключатель ровных краёв
  cp5.addToggle("smoothEdges")
    .setPosition(65, 5)
    .setSize(50, 20)
    .setGroup(options)
    .setValue(smoothEdges)
    ;
  
  Group file = cp5.addGroup("file")
    .setPosition(0,580)
    .setSize(200, 65)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(65)
    .setLabel("file")
    ;
   
  // кнопка сохранения obj
  cp5.addButton("saveOBJ")
    .setValue(0)
    .setPosition(5,5)
    .setSize(70,25)
    .setLabel("save OBJ")
    .setGroup(file)
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        selectOutput("Select a file to save:", "fileSelectedToSaveOBJ");
        }
      })
    ;
   
  // кнопка загрузки obj
  cp5.addButton("loadOBJ")
    .setValue(0)
    .setPosition(85,5)
    .setSize(70,25)
    .setLabel("load OBJ")
    .setGroup(file)
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        selectInput("Выберите .obj файл:", "fileSelectedToLoad"); // Открываем окно выбора файла при старте
        }
      })
    ;
   
  // кнопка сохранения x
  cp5.addButton("saveX")
    .setValue(0)
    .setPosition(5,35)
    .setSize(70,25)
    .setLabel("save X")
    .setGroup(file)
    .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        selectOutput("Select a file to save:", "fileSelectedToSaveX");
        }
      })
    ;
   
  Group design = cp5.addGroup("design")
    .setPosition(0,670)
    .setSize(200, 80)
    .activateEvent(true)
    .setBackgroundColor(color(255,80))
    .setBackgroundHeight(80)
    .setLabel("design")
    ;
   
  //слайдер изменения цвета
  cp5.addSlider("color")
    .setPosition(5, 5)
    .setSize(150, 20)
    .setRange(0, 255)
    .setGroup(design)
    .setValue(150)
    ;
  
  //слайдер изменения прозрачности
  cp5.addSlider("alpha")
    .setPosition(5, 30)
    .setSize(150, 20)
    .setRange(0, 255)
    .setGroup(design)
    .setValue(150)
    ;
  
  //слайдер изменения прозрачности граней
  cp5.addSlider("stroke")
    .setPosition(5, 55)
    .setSize(150, 20)
    .setRange(0, 255)
    .setGroup(design)
    .setValue(150)
    ;
}

CallbackListener handleInteraction = e -> {
    lastActiveTime = millis(); 
    showCuttingPlane = true;
  };

// Обработка изменений параметров
// Обработка параметров detail, cutoff, radius
void controlEvent(ControlEvent event) {
  if (event.isFrom("detail") || event.isFrom("cutoff") || event.isFrom("radius")) {
    detail = (int)cp5.getController("detail").getValue();
    cutoff = cp5.getController("cutoff").getValue();
    radius = cp5.getController("radius").getValue();
    cp5.get(Textfield.class, "detail_text").setText(str((int)detail));
    cp5.get(Textfield.class, "cutoff_text").setText(str((float)cutoff));
    cp5.get(Textfield.class, "radius_text").setText(str((float)radius));
    createDome();
  }
  // Обработка параметров cutoffAngleZ, cutoffAngleY, cutoffAngleX
  if (event.isFrom("cutoffAngleZ") || event.isFrom("cutoffAngleY") || event.isFrom("cutoffAngleX")) {
    cutoffAngleZ = radians(cp5.getController("cutoffAngleZ").getValue());
    cutoffAngleX = radians(cp5.getController("cutoffAngleX").getValue());
    cutoffAngleY = radians(cp5.getController("cutoffAngleY").getValue());
    
    // Обновляем текстовые поля (в градусах)
    cp5.get(Textfield.class, "cutoffAngleZ_text").setText(str(cp5.getController("cutoffAngleZ").getValue()));
    cp5.get(Textfield.class, "cutoffAngleX_text").setText(str(cp5.getController("cutoffAngleX").getValue()));
    cp5.get(Textfield.class, "cutoffAngleY_text").setText(str(cp5.getController("cutoffAngleY").getValue()));
    
    createDome();
  }
  // Обработка параметров showEdges, smoothEdges
  if (event.isFrom("showEdges") || event.isFrom("smoothEdges")) {
    showEdges = cp5.getController("showEdges").getValue() == 1;
    smoothEdges = cp5.getController("smoothEdges").getValue() == 1;
  }
  // Обработка параметра radio_g1
  if(event.isFrom("radio_g1")) {
    polyhedronType = event.getValue() == 1.0 ? "octahedron" : "icosahedron";
    createDome();
  }
  // Обработка параметра radio_g2
   if(event.isFrom("radio_g2")) {
    detailingType = event.getValue() == 1.0 ? "alternate" : "recursionMethod";
    createDome();
  }
  //Обработка изменений значений текстовых полей, синхронизация их со слайдерами
   if (event.isFrom(cp5.get(Textfield.class, "detail_text")) || 
       event.isFrom(cp5.get(Textfield.class, "cutoff_text")) || 
       event.isFrom(cp5.get(Textfield.class, "radius_text"))) {
        try {
          int newdetail = Integer.parseInt(cp5.get(Textfield.class, "detail_text").getText());
          float newcutoff = Float.parseFloat(cp5.get(Textfield.class, "cutoff_text").getText());
          float newradius = Float.parseFloat(cp5.get(Textfield.class, "radius_text").getText());
          
          cp5.getController("detail").setValue(newdetail);
          cp5.getController("cutoff").setValue(newcutoff);
          cp5.getController("radius").setValue(newradius);
          
          cp5.get(Textfield.class, "detail_text").setFocus(false);
          cp5.get(Textfield.class, "cutoff_text").setFocus(false);
          cp5.get(Textfield.class, "radius_text").setFocus(false);

        } catch (NumberFormatException e) {
          cp5.get(Textfield.class, "detail_text").setFocus(false);
          cp5.get(Textfield.class, "cutoff_text").setFocus(false);
          cp5.get(Textfield.class, "radius_text").setFocus(false);
          
          cp5.get(Textfield.class, "detail_text").setValue(str(detail));
          cp5.get(Textfield.class, "cutoff_text").setValue(str(cutoff));
          cp5.get(Textfield.class, "radius_text").setValue(str(radius));
        }
      }
      
    if (event.isFrom(cp5.get(Textfield.class, "cutoffAngleZ_text")) || 
        event.isFrom(cp5.get(Textfield.class, "cutoffAngleX_text")) || 
        event.isFrom(cp5.get(Textfield.class, "cutoffAngleY_text"))) {
        try {
            float newAngleZ = Float.parseFloat(cp5.get(Textfield.class, "cutoffAngleZ_text").getText());
            float newAngleX = Float.parseFloat(cp5.get(Textfield.class, "cutoffAngleX_text").getText());
            float newAngleY = Float.parseFloat(cp5.get(Textfield.class, "cutoffAngleY_text").getText());
            
            // Устанавливаем значения слайдеров (в градусах)
            cp5.getController("cutoffAngleZ").setValue(newAngleZ);
            cp5.getController("cutoffAngleX").setValue(newAngleX);
            cp5.getController("cutoffAngleY").setValue(newAngleY);
            
            // Обновляем углы в радианах
            cutoffAngleZ = radians(newAngleZ);
            cutoffAngleX = radians(newAngleX);
            cutoffAngleY = radians(newAngleY);
            
            createDome();
        } catch (NumberFormatException e) {
            // Если введено не число, восстанавливаем предыдущие значения
            cp5.get(Textfield.class, "cutoffAngleZ_text").setText(str(cp5.getController("cutoffAngleZ").getValue()));
            cp5.get(Textfield.class, "cutoffAngleX_text").setText(str(cp5.getController("cutoffAngleX").getValue()));
            cp5.get(Textfield.class, "cutoffAngleY_text").setText(str(cp5.getController("cutoffAngleY").getValue()));
        }
    }
   // Обработка параметров color, alpha, stroke
   if (event.isFrom("color") || event.isFrom("alpha") || event.isFrom("stroke")) {
    colorDome = (int)cp5.getController("color").getValue();
    transparencyDome = (int)cp5.getController("alpha").getValue();
    transparencyDomeStroke = (int)cp5.getController("stroke").getValue();
    createDome();
}
}


void drawHUD() {
  // Сохраняем текущую матрицу преобразований
  pushMatrix();
  
  // Сбрасываем все преобразования (включая камеру)
  resetMatrix();
  
  // Устанавливаем 2D-режим для отрисовки текста
  hint(DISABLE_DEPTH_TEST); // Отключаем тест глубины для текста
  cam.beginHUD();
  
    // Рисуем фон для левой части окна
  fill(60); // Серый цвет фона
  noStroke(); // Убираем обводку
  rect(0, 0, 200, 768); // Прямоугольник на всю левую часть окна
  
  fill(255); // Цвет текста
  textSize(14); // Размер текста
  String infoText = "FPS: " + (int)frameRate + "\n" +
                  "Метод разбивки: " + (detailingType.equals("recursionMethod") ? "Recursion method" : "Alternate") + "\n" +
                  "Базовый многогранник: " + (polyhedronType.equals("icosahedron") ? "Icosahedron" : "Octahedron") + "\n" +
                  "Количество треугольников: " + countTriangles + "\n" +
                  "Частота детализации: " + frequency + "\n" +
                  "Обрезка: " + cutoff + "\n" +
                  "Радиус: " + radius + "\n" +
                  "Только грани: " + (showEdges ? "да" : "нет") + "\n" +
                  "Дополнять до плоскости: " + (smoothEdges ? "да" : "нет");

  text(infoText, 750, 10, 274, 384);
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST); // Включаем тест глубины обратно
  
  // Восстанавливаем матрицу преобразований
  popMatrix();
}

void draw3DScene() {
  pushMatrix();  // Сохраняем текущую систему координат
  translate(612, 384, 0);  // Перемещаем сцену в центр
  background(50);  // Устанавливаем фоновый цвет
  lights();  // Включаем освещение
  
  drawDome();  // Рисуем купол (Triangle.pde)

    // Автоматическое скрытие через 2 секунда неактивности
  if (showCuttingPlane && millis() - lastActiveTime > hideDelay) {
    showCuttingPlane = false;
  }
  popMatrix();  // Восстанавливаем систему координат
}
