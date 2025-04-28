int[] getColorDome() {
  // Нормализуем colorDome в диапазоне от 0 до TWO_PI (полный цикл)
  float normalizedValue = map(colorDome, 0, 255, 0, TWO_PI);
  
  // Вычисляем значения R, G, B с использованием синусоидальных функций
  int r = int(128 + 127 * sin(normalizedValue));
  int g = int(128 + 127 * sin(normalizedValue + TWO_PI / 3));
  int b = int(128 + 127 * sin(normalizedValue + TWO_PI * 2 / 3));
  
  // Ограничиваем значения RGB в диапазоне от 0 до 255
  r = constrain(r, 0, 255);
  g = constrain(g, 0, 255);
  b = constrain(b, 0, 255);
  
  // Возвращаем массив с значениями r, g, b
  return new int[]{r, g, b};
}

void fileSelectedToSaveOBJ(File selection) {
  if (selection == null) {
    println("Export canceled");
  } else {
    String path = selection.getAbsolutePath();
    // Добавляем расширение .obj, если его нет
    if (!path.toLowerCase().endsWith(".obj")) {
      path += ".obj";
    }
    exportToOBJ(path);
  }
}


void exportToOBJ(String filePath) {
  try {
    //String filePath = folderPath + "/" + filename + ".obj";
    PrintWriter output = createWriter(filePath);
    output.println("# params: \n" + 
                  "# detail: " + detail + "\n" + 
                  "# cutoff: " + cutoff + "\n" +  
                  "# radius: " + radius + "\n"  +  
                  "# polyhedronType: " + polyhedronType + "\n" +  
                  "# showEdges: " + showEdges + "\n" +  
                  "# smoothEdges: " + smoothEdges + "\n" + "\n"
                  );
    
    int vertexIndex = 1;
    HashMap<PVector, Integer> vertexMap = new HashMap<PVector, Integer>(); 
    
    for (Triangle t : domeTriangles) {
      if(smoothEdges){
        ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
        for (Triangle ct : cutTriangles) {
          for (PVector v : new PVector[] {ct.v1, ct.v2, ct.v3}) {
            if (!vertexMap.containsKey(v)) {
              vertexMap.put(v, vertexIndex);
              output.println("v " + v.x + " " + v.y + " " + v.z);
              vertexIndex++;
            }
          }
        }
      } else {
          if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
            for (PVector v : new PVector[] {t.v1, t.v2, t.v3}) {
              if (!vertexMap.containsKey(v)) {
                vertexMap.put(v, vertexIndex);
                output.println("v " + v.x + " " + v.y + " " + v.z);
                vertexIndex++;
              }
            }
        }
      }
    }

    for (Triangle t : domeTriangles) {
      if(smoothEdges){
        ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
        for (Triangle ct : cutTriangles) {
          int idx1 = vertexMap.get(ct.v1);
          int idx2 = vertexMap.get(ct.v2);
          int idx3 = vertexMap.get(ct.v3);
          output.println("f " + idx1 + " " + idx2 + " " + idx3);
        }
      } else {
          if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
            int idx1 = vertexMap.get(t.v1);
            int idx2 = vertexMap.get(t.v2);
            int idx3 = vertexMap.get(t.v3);
            output.println("f " + idx1 + " " + idx2 + " " + idx3);
        }
      }
    }    
    
    output.flush();
    output.close();
    println("OBJ file saved as " + filePath);
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void fileSelectedToSaveX(File selection) {
  if (selection == null) {
    println("Export canceled");
  } else {
    String path = selection.getAbsolutePath();
    // Добавляем расширение .x, если его нет
    if (!path.toLowerCase().endsWith(".x")) {
      path += ".x";
    }
    exportToX(path);
  }
}

void exportToX(String filePath) {
  try {
    PrintWriter output = createWriter(filePath);

    // Заголовок файла
    output.println("xof 0303txt 0032");
    output.println("Header { 1;0;1; }");
    output.println();

    // Открываем блок Mesh
    output.println("Mesh Dome {");

    HashMap<PVector, Integer> vertexMap = new HashMap<>();
    ArrayList<PVector> vertexList = new ArrayList<>();


    
  //  for (Triangle t : domeTriangles) {
  //  if (smoothEdges) {
  //    ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
  //    for (Triangle ct : cutTriangles) {
  //      counter++;
  //      ct.display();
  //    }
  //  } else {
  //    // Оптимизированная проверка всех вершин
  //    if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
  //        t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
  //        t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
  //      counter++;
  //      t.display();
  //    }
  //  }
  //}
    
   



    // Добавляем вершины (уникальные)
    int vertexIndex = 0;
    for (Triangle t : domeTriangles) {
      if (smoothEdges) {
        ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
        for (Triangle ct : cutTriangles) {
          for (PVector v : new PVector[] { ct.v1, ct.v2, ct.v3 }) {
            if (!vertexMap.containsKey(v)) {
              vertexMap.put(v, vertexIndex++);
              vertexList.add(v);
            }
          }
        }
      } else {
          if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
            for (PVector v : new PVector[] { t.v1, t.v2, t.v3 }) {
              if (!vertexMap.containsKey(v)) {
                vertexMap.put(v, vertexIndex++);
                vertexList.add(v);
            }
          }
        }
      }
    }

    // Записываем вершины
    output.println("  " + vertexList.size() + ";");
    for (int i = 0; i < vertexList.size(); i++) {
      PVector v = vertexList.get(i);
      output.println("  " + v.x + ";" + v.y + ";" + v.z + (i == vertexList.size() - 1 ? ";" : ";,"));
    }

    output.println();

    // Добавляем индексы треугольников
    ArrayList<String> faceList = new ArrayList<>();
    for (Triangle t : domeTriangles) {
      if (smoothEdges) {
        ArrayList<Triangle> cutTriangles = t.cut(cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY);
        for (Triangle ct : cutTriangles) {
          int idx1 = vertexMap.get(ct.v1);
          int idx2 = vertexMap.get(ct.v2);
          int idx3 = vertexMap.get(ct.v3);
          faceList.add("3;" + idx1 + "," + idx2 + "," + idx3 + ";");
          faceList.add("3;" + idx3 + "," + idx2 + "," + idx1 + ";");
        }
      } else {
          if (t.isVertexBelow(t.v1, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v2, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY) &&
            t.isVertexBelow(t.v3, cutoff * radius, cutoffAngleZ, cutoffAngleX, cutoffAngleY)) {
            int idx1 = vertexMap.get(t.v1);
            int idx2 = vertexMap.get(t.v2);
            int idx3 = vertexMap.get(t.v3);
            faceList.add("3;" + idx1 + "," + idx2 + "," + idx3 + ";");
            faceList.add("3;" + idx3 + "," + idx2 + "," + idx1 + ";");
        }
      }
    }

    // Записываем грани
    output.println("  " + faceList.size() + ";");
    for (int i = 0; i < faceList.size(); i++) {
      output.println("  " + faceList.get(i) + (i == faceList.size() - 1 ? "" : ","));
    }

    // Добавляем MeshMaterialList
    output.println("MeshMaterialList {");
    output.println("  1;"); // Один материал
    output.println("  " + faceList.size() + ";"); // Количество граней
    for (int i = 0; i < faceList.size(); i++) {
      output.println("  0" + (i == faceList.size() - 1 ? ";" : ",")); // Все грани используют материал 0
    }
    output.println();
    
    // Добавляем Material
    output.println("  Material {");
    output.println("    0.0; 1.0; 0.0; 0.75;;"); // Зеленый цвет, 75% прозрачности
    output.println("    0.2;"); // Specular power (для выделения граней)
    output.println("    0.2; 0.2; 0.2;;"); // Ambient
    output.println("    0.8; 0.8; 0.8;;"); // Specular (яркость граней)
    output.println("  }");
    output.println("}"); // Закрываем MeshMaterialList
    output.println("}"); // Закрываем Mesh

    output.flush();
    output.close();

    println("X file saved as " + filePath);
  } catch (Exception e) {
    e.printStackTrace();
  }
}


void fileSelectedToLoad(File selection) {
  if (selection == null) {
    println("Файл не выбран.");
    exit();
  } else {
    String filePath = selection.getAbsolutePath();
    loadOBJ(filePath);  // Загружаем выбранный файл
  }
}

void loadOBJ(String filePath) {
  domeTriangles.clear(); // Очищаем массив перед загрузкой новых треугольников
  ArrayList<PVector> vertices = new ArrayList<PVector>();

  try {
    BufferedReader br = new BufferedReader(new FileReader(filePath));
    String line;
    
    while ((line = br.readLine()) != null) {
      String[] tokens = line.split("\\s+");
      
      if (tokens[0].equals("v")) {
        // Считываем вершины
        float x = Float.parseFloat(tokens[1]);
        float y = Float.parseFloat(tokens[2]);
        float z = Float.parseFloat(tokens[3]);
        vertices.add(new PVector(x, y, z));
        
      } else if (tokens[0].equals("f")) {
        // Считываем грани (треугольники)
        int[] face = new int[tokens.length - 1];
        for (int i = 1; i < tokens.length; i++) {
          face[i - 1] = Integer.parseInt(tokens[i].split("/")[0]) - 1;  // Индексы вершин
        }
        
        // Добавляем ВСЕ треугольники без проверки плоскости
        PVector v1 = vertices.get(face[0]);
        PVector v2 = vertices.get(face[1]);
        PVector v3 = vertices.get(face[2]);
        domeTriangles.add(new Triangle(v1, v2, v3));
      }
    }
    cutoff = 1.0;
    br.close();
    
    if (vertices.size() == 0 && domeTriangles.size() == 0) {
      println("Ошибка загрузки .obj файла: файл пуст или неверный формат.");
    } else {
      println("Модель загружена: " + vertices.size() + " вершин, " + domeTriangles.size() + " треугольников.");
    }
    
  } catch (Exception e) {
    println("Ошибка загрузки .obj файла: " + e.getMessage());
  }
}
