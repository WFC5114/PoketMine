using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class BushEncounter : MonoBehaviour
{
    public GameObject[] creatures; // Array of potential creatures to encounter
    private bool hasCreature; // Flag to determine if this bush has a creature

    void Start()
    {
        // Randomly decide if this bush contains a creature
        hasCreature = Random.value < 1f; // 20% chance for this bush to contain a creature
        Debug.Log("Has Creature: " + hasCreature);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        Debug.Log("Before Encounter Check - Has Creature: " + hasCreature);
        Debug.Log("OnTriggerEnter2D called with: " + collision.gameObject.name);

        if (collision.CompareTag("Player"))
        {
            Debug.Log("Player tag confirmed.");
        }
        else
        {
            Debug.Log("Collision not with player.");
        }

        if (hasCreature)
        {
            Debug.Log("Bush has a creature.");
        }
        else
        {
            Debug.Log("Bush does not have a creature.");
        }

        if (collision.CompareTag("Player") && hasCreature)
        {
            Debug.Log("Both conditions met: Player tag confirmed and bush has a creature.");
            EncounterCreature();
            SceneManager.LoadScene("MiniGame(Arrow)");
        }

    }

    void EncounterCreature()
    {
        // Encounter logic here
        Debug.Log("EncounterCreature method called.");
        Debug.Log("Creature encountered!");
        // Here you would typically instantiate the creature, initiate a battle, etc.
    }
}