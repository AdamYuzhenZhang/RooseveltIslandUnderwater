using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class TreePlanter : MonoBehaviour
{
    public GameObject[] trees;

    private void Start()
    {
        StartCoroutine(PlantTrees());
    }

    IEnumerator PlantTrees()
    {
        foreach (GameObject tree in trees)
        {
            tree.SetActive(false);
        }
        foreach (GameObject tree in trees)
        {
            yield return new WaitForSeconds(Random.Range(0.3f, 1f));
            tree.SetActive(true);
        }
    }
}
