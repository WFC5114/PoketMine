using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MiniGameController : MonoBehaviour
{
    public float delayBeforeLoading = 2.0f;  // Delay in seconds

    public void EndMiniGame(bool success)
    {
        StartCoroutine(EndGameAfterDelay(success));
    }

    private IEnumerator EndGameAfterDelay(bool success)
    {
        // Optionally pass success or other results back to the main game
        PlayerPrefs.SetInt("MiniGameSuccess", success ? 1 : 0);

        // Wait for specified delay before loading the scene
        yield return new WaitForSeconds(delayBeforeLoading);

        // Load the main game scene
        SceneManager.LoadScene("Main");  // Replace with your main game scene name
    }
}


