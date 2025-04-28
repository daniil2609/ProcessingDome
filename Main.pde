// Импортируем библиотеки
import peasy.*;  // Библиотека PeasyCam для управления камерой
import controlP5.*;  // Библиотека ControlP5 для создания графического интерфейса
import java.util.ArrayList;  // Подключаем ArrayList для работы с массивами объектов
import processing.opengl.*;  // Подключаем OpenGL для 3D-графики
import java.io.*;  // Подключаем библиотеки для работы с файлами

// Объявляем глобальные переменные
PeasyCam cam;  // Камера для 3D-навигации
ControlP5 cp5;  // GUI контроллер
PVector lastPlaneNormal = new PVector(0, 0, 1);
PVector camLookAt = new PVector(0, 0, 0);
double camDistance = 1000;

// Параметры купола
int frequency;  // Частота разбиения (детализация)
int detail;  // Глубина разбиения
float cutoff;  // Уровень отсечения (0 - нет отсечения)
float radius;  // Радиус купола
String polyhedronType = "icosahedron";  // Тип многогранника ("icosahedron" или "octahedron")
String detailingType = "recursionMethod";  // Тип разбиения ("alternate" или "triacon")
boolean showEdges = false;  // Флаг отображения рёбер
boolean smoothEdges = true;  // Флаг сглаживания рёбер
int countTriangles;  // Количество треугольников в куполе
int colorDome; //цвет купола
int transparencyDome; //прозрачность купола
int transparencyDomeStroke; //видимость граней
float cutoffAngleZ; // Угол поворота плоскости отсечения Z(в радианах)
float cutoffAngleX; // Угол поворота плоскости вокруг оси X
float cutoffAngleY; // Угол поворота плоскости вокруг оси Y

boolean showCuttingPlane = false;
int hideDelay = 2000; // 2 секунды задержки для скрытия плоскости
int lastActiveTime = 0;
float planeAlpha = 0;

void setup() {
  size(1024, 768, P3D);  // Устанавливаем размер окна и используем OpenGL для рендеринга
  cam = new PeasyCam(this, 612, 384, 0, 100);  // Создаём камеру, центр в (612, 384), расстояние 300
  cam.setViewport(200, 0, 1024, 768);  // Устанавливаем область просмотра камеры
  cam.rotateX(8);  // Поворачиваем камеру по X
  
  setupGUI();  // Создаём графический интерфейс (GUI.pde)
  
  createDome();  // Создаём купол (Triangle.pde)
}

void draw() {
  draw3DScene();  // Отрисовываем 3D-сцену (GUI.pde)
  drawHUD();  // Отображаем интерфейс (GUI.pde)
}
