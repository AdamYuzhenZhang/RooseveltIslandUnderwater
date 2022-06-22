using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterLevelController : MonoBehaviour
{
    public GameObject waterLevel;
    public GameObject camera;
    // whether to move water up or down
    public bool moveDown;
    public bool moveUp;
    public float minLevel;
    public float maxLevel;
    public float moveUpSpeed = 0.1f;
    public float moveDownSpeed = 0.1f;

    private Color normalColor = new Color(0.75f, 0.75f, 0.85f, 0.5f);
    private Color underwaterColor = new Color(0.25f, 0.25f, 0.4f, 0.22f);

    // Start is called before the first frame update
    void Start()
    {
        RenderSettings.fogColor = normalColor;
        RenderSettings.fogDensity = 0.0001f;
        //RenderSettings.fog = false;
        //Debug.Log("RenderSettings Changed");
    }

    // Update is called once per frame
    void Update()
    {
        if (moveDown && minLevel < waterLevel.transform.localPosition.y)
        {
            //Debug.Log("moving water level down");
            float targetY = waterLevel.transform.localPosition.y - moveDownSpeed * Time.deltaTime;
            if (targetY < minLevel)
            {
                targetY = minLevel;
                moveDown = false;
            }
            waterLevel.transform.localPosition = new Vector3(0f, targetY, 0f);
        } 
        else if (moveUp && waterLevel.transform.localPosition.y < maxLevel)
        {
            //Debug.Log("moving water level up");
            float targetY = waterLevel.transform.localPosition.y + moveUpSpeed * Time.deltaTime;
            if (targetY > maxLevel)
            {
                targetY = maxLevel;
                moveUp = false;
            }
            waterLevel.transform.localPosition = new Vector3(0f, targetY, 0f);
        }
        CheckWaterLevel();
    }

    public void moveWaterUp()
    {
        moveDown = false;
        moveUp = true;
    }

    public void moveWaterDown()
    {
        moveDown = true;
        moveUp = false;
    }

    public void setMoveUpSpeed(float speed)
    {
        moveUpSpeed = speed;
    }
    
    public void setMoveDownSpeed(float speed)
    {
        moveDownSpeed = speed;
    }

    private void CheckWaterLevel()
    {
        if (camera.transform.position.y < waterLevel.transform.position.y)
        {
            // underwater
            RenderSettings.fogColor = underwaterColor;
            RenderSettings.fogDensity = 0.02f + (waterLevel.transform.position.y - camera.transform.position.y) / 1000f;
        }
        else
        {
            // above water
            RenderSettings.fogColor = normalColor;
            RenderSettings.fogDensity = 0.0001f;
        }
    }
    
    public void MoveWaterToLevel(float newWaterLevel)
    {
        if (waterLevel.transform.position.y < newWaterLevel)
        {
            maxLevel = newWaterLevel;
            moveWaterUp();
        }
        else
        {
            minLevel = newWaterLevel;
            moveWaterDown();
        }
    }
}
