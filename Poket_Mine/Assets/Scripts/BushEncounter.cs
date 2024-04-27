using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using System.Numerics;

public class BushEncounter : MonoBehaviour
{
    public GameObject[] creatures; // Array of potential creatures to encounter
    private bool hasCreature; // Flag to determine if this bush has a creature

    void Start()
    {
        // Randomly decide if this bush contains a creature
        hasCreature = Random.value < 1f; // 100% chance for this bush to contain a creature
        Debug.Log("Has Creature: " + hasCreature);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        Debug.Log("Before Encounter Check - Has Creature: " + hasCreature);
        Debug.Log("OnTriggerEnter2D called with: " + collision.gameObject.name);

        if (collision.CompareTag("Player"))
        {
            Debug.Log("Player tag confirmed.");
            if (hasCreature)
            {
                Debug.Log("Bush has a creature. Attempting to encounter.");
                BigInteger tokenId = BigInteger.Parse("1"); // Example Token ID for the creature
                ContractInteractor contractInteractor = FindObjectOfType<ContractInteractor>();
                contractInteractor.GetCreatureAttributes(tokenId);
                SceneManager.LoadScene("MiniGame(Arrow)");
            }
        }
    }
}
