using System;
using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;
public class ScriptController : MonoBehaviour
{
    public WaterLevelController waterLevelController;
    public GameObject boat;
    public GameObject[] boatParticles;
    public Material waterMat;
    public GameObject groundToHide;

    public CinemachineDollyCart car1;
    public CinemachineDollyCart car2;
    public CinemachineDollyCart car3;

    private float targetWaveAmplitude;
    private float currentWaveAmplitude = 0.2f;
    private bool changeWaveAmplitude;
    
    public GameObject indicatorUI;
    public GameObject indicatorWaterRoot;
    public TextMesh waterText;
    //public Renderer waterRenderer;
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("EventTrigger"))
        {
            int eventNumber = other.GetComponent<EventSequence>().EventNumber;
            Debug.Log("Event Called");
            Debug.Log(eventNumber);
            switch (eventNumber)
            {
                case 0:
                    // Water rising high quickly
                    SetMaxWaterHeight(0.42f);
                    WaterUp_Quick();
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.8f;
                    //waterMat.SetFloat("_WaveAmplitude", 0.7f);

                    break;
                case 1:
                    // Water coming down quickly
                    SetMinWaterHeight(0.148f);
                    WaterDown_Quick();
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.12f;
                    //waterMat.SetFloat("_WaveAmplitude", 0.2f);
                    break;
                case 100:
                    // Move Car
                    car1.enabled = true;
                    break;
                case 2:
                    // Water rising medium
                    SetMinWaterHeight(0f);
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.15f;
                    //waterMat.SetFloat("_WaveAmplitude", 0.2f);
                    groundToHide.SetActive(true);
                    WaterDown_Slow();
                    break;
                case 101:
                    // Water rising medium
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.8f;
                    //waterMat.SetFloat("_WaveAmplitude", 0.8f);
                    break;
                case 3:
                    // boat passes by near the bus
                    boat.SetActive(true);
                    boat.GetComponent<CinemachineDollyCart>().enabled = true;
                    
                    //boat.SetActive(true);
                    //foreach (GameObject particle in boatParticles)
                    //{
                    //    EnableParticle(particle);
                    //}
                    break;
                case 4:
                    // hide high ground
                    groundToHide.SetActive(false);
                    break;
                case 5:
                    // 1950 -9 inch
                    indicatorUI.SetActive(true);
                    waterText.text = "1950\nWater Level\n-9 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.35f, 0.9f);
                    SetMinWaterHeight(-0.02f);
                    WaterDown_Slow();
                    break;
                case 6:
                    // current 0 inch
                    waterText.text = "Current\nWater Level\n0 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.4f, 0.9f);
                    SetMaxWaterHeight(0f);
                    WaterUp_Slow();
                    break;
                case 7:
                    // next 14 years 6 inch
                    waterText.text = "2032\nWater Level\n10 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.45f, 0.9f);
                    SetMaxWaterHeight(0.02f);
                    WaterUp_Slow();
                    break;
                case 71:
                    // 2042
                    waterText.text = "2042\nWater Level\n16 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.48f, 0.9f);
                    SetMaxWaterHeight(0.04f);
                    WaterUp_Slow();
                    break;
                case 72:
                    // 2052
                    waterText.text = "2052\nWater Level\n23 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.52f, 0.9f);
                    SetMaxWaterHeight(0.06f);
                    WaterUp_Slow();
                    break;
                case 73:
                    // 2062
                    waterText.text = "2062\nWater Level\n31 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.56f, 0.9f);
                    SetMaxWaterHeight(0.09f);
                    WaterUp_Slow();
                    break;
                case 74:
                    // till 2072 40 inch
                    waterMat.SetFloat("_FoamSize", 3.2f);
                    waterText.text = "2072\nWater Level\n40 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.62f, 0.9f);
                    SetMaxWaterHeight(0.16f);
                    WaterUp_Quick();
                    break;
                case 9:
                    // Tram stop
                    // Storm Surge
                    //MoveWaterToLevel(0.2f);
                    waterMat.SetFloat("_FoamSize", 3.4f);
                    waterText.text = " \nStorm Surge\n ";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.72f, 0.9f);
                    SetMaxWaterHeight(0.162f);
                    WaterUp_Quick();
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.9f;
                    break;
                case 10:
                    // 96 inches
                    waterText.text = "In 100 years\nWater Level\n96 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.7f, 0.9f);
                    SetMinWaterHeight(0.16f);
                    WaterDown_Slow();
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.3f;
                    break;
                case 11:
                    // Tidal Flooding
                    waterMat.SetFloat("_FoamSize", 3.6f);
                    waterText.text = " \nTidal Flooding\n ";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.74f, 0.9f);
                    SetMaxWaterHeight(0.164f);
                    WaterUp_Slow();
                    break;
                case 12:
                    car2.enabled = true;
                    car3.enabled = true;
                    // Remote Hurricane
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 1f;
                    break;
                case 13:
                    // Tidal Flooding
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.15f;
                    break;
                case 14:
                    waterText.text = "In 100 years\nWater Level\n96 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.7f, 0.9f);
                    SetMinWaterHeight(0.16f);
                    WaterDown_Slow();
                    changeWaveAmplitude = true;
                    targetWaveAmplitude = 0.2f;
                    break;
                case 15:
                    waterText.text = "In 50 years\nWater Level\n40 inch";
                    indicatorWaterRoot.transform.localScale = new Vector3(0.9f, 0.62f, 0.9f);
                    SetMinWaterHeight(0.12f);
                    WaterDown_Slow();
                    break;
            }
        }
    }

    private void Start()
    {
        indicatorUI.SetActive(false);
    }

    private void Update()
    {
        if (changeWaveAmplitude)
        {
            ChangeWaveAmp(Time.deltaTime);
        }
    }

    private void ChangeWaveAmp(float deltaTime)
    {
        if (targetWaveAmplitude < currentWaveAmplitude)
        {
            currentWaveAmplitude -= (deltaTime * 0.2f);
            waterMat.SetFloat("_WaveAmplitude", currentWaveAmplitude);
        }

        if (targetWaveAmplitude > currentWaveAmplitude)
        {
            currentWaveAmplitude += (deltaTime * 0.2f);
            waterMat.SetFloat("_WaveAmplitude", currentWaveAmplitude);
        }

        if (Math.Abs(targetWaveAmplitude - currentWaveAmplitude) < 0.1)
        {
            changeWaveAmplitude = false;
        }
    }

    private void SetMaxWaterHeight(float height)
    {
        waterLevelController.maxLevel = height;
    }
    private void SetMinWaterHeight(float height)
    {
        waterLevelController.minLevel = height;
    }
    private void WaterUp_Quick()
    {
        waterLevelController.setMoveUpSpeed(0.012f);
        waterLevelController.moveWaterUp();
    }
    private void WaterDown_Quick()
    {
        waterLevelController.setMoveDownSpeed(0.012f);
        waterLevelController.moveWaterDown();
    }
    private void WaterUp_Slow()
    {
        waterLevelController.setMoveUpSpeed(0.006f);
        waterLevelController.moveWaterUp();
    }
    private void WaterDown_Slow()
    {
        waterLevelController.setMoveDownSpeed(0.008f);
        waterLevelController.moveWaterDown();
    }

    private void MoveWaterToLevel(float waterLevel)
    {
        waterLevelController.setMoveUpSpeed(0.01f);
        waterLevelController.setMoveDownSpeed(0.01f);
        waterLevelController.MoveWaterToLevel(waterLevel);
    }

    private void EnableParticle(GameObject particle)
    {
        particle.GetComponent<ParticleSystem>().Play();
        ParticleSystem.EmissionModule em = particle.GetComponent<ParticleSystem>().emission;
        em.enabled = true;
    }
}